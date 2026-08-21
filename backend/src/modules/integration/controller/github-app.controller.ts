import { Request, Response } from 'express';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { env } from '../../../config/env';
import { GitHubInstallation, GitHubInstallationStatus } from '../model/github-installation.model';
import { githubClient } from '../clients/github.client';
import { logger } from '../../../config/logger';

export class GitHubAppController {
  
  /**
   * Generates the GitHub App installation URL.
   * State parameter includes the organizationId to link it back after installation.
   */
  async getInstallUrl(req: Request, res: Response) {
    try {
      const organizationId = req.user?.organizationId;
      const appName = env.GITHUB_APP_NAME;

      if (!appName) {
        return ApiResponse.error(res, 'GitHub App Name not configured', null, 500);
      }

      const state = Buffer.from(JSON.stringify({ organizationId })).toString('base64');
      const installUrl = `https://github.com/apps/${appName}/installations/new?state=${state}`;

      return ApiResponse.success(res, { url: installUrl }, 'Install URL generated');
    } catch (error: any) {
      logger.error({ error }, 'Failed to generate GitHub App install URL');
      return ApiResponse.error(res, error.message, null, 500);
    }
  }

  /**
   * Handles the redirect from GitHub after an app is installed.
   * Creates the GitHubInstallation record in the database.
   */
  async handleCallback(req: Request, res: Response) {
    try {
      const installation_id = req.query.installation_id as string;
      const setup_action = req.query.setup_action as string;
      const state = req.query.state as string;

      logger.info({ installation_id, setup_action }, 'GitHub App callback received');

      if (!installation_id || (setup_action !== 'install' && setup_action !== 'update')) {
        return res.status(400).send('Invalid callback parameters');
      }

      let organizationId: string;
      try {
        const decodedState = JSON.parse(Buffer.from(state as string, 'base64').toString('utf-8'));
        organizationId = decodedState.organizationId;
        logger.info({ organizationId }, 'Resolved authenticated Orivox organization');
      } catch (err) {
        return res.status(400).send('Invalid state parameter');
      }

      if (!organizationId) {
        return res.status(400).send('Missing organization context');
      }

      logger.info({ installation_id }, 'Starting repository fetch from GitHub');
      // We need to fetch details about this installation from GitHub using our App JWT
      const token = await githubClient.getInstallationToken(Number(installation_id));
      
      const repos = await githubClient.listInstallationRepositories(Number(installation_id));
      logger.info({ repositoryCount: repos.repositories?.length }, 'GitHub API repository fetch completed');
      
      let accountId = 0;
      let accountLogin = 'Unknown';
      let accountType = 'Unknown';

      if (repos.repositories && repos.repositories.length > 0) {
        const owner = repos.repositories[0].owner;
        accountId = owner.id;
        accountLogin = owner.login;
        accountType = owner.type;
      }

      await GitHubInstallation.findOneAndUpdate(
        { installationId: Number(installation_id) },
        {
          organizationId,
          githubAccountId: accountId,
          githubAccountLogin: accountLogin,
          githubAccountType: accountType,
          status: GitHubInstallationStatus.ACTIVE,
        },
        { upsert: true, new: true }
      );

      logger.info({ installation_id, organizationId }, 'Installation successfully persisted to organization');

      res.send(`
        <html>
          <head>
            <title>GitHub Connected</title>
            <style>
              body { font-family: sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; background-color: #f9fafb; margin: 0; }
              .container { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; }
              h1 { color: #10b981; }
              p { color: #4b5563; margin-top: 16px; }
            </style>
          </head>
          <body>
            <div class="container">
              <h1>GitHub Connected Successfully</h1>
              <p>You can close this window and return to Orivox.</p>
            </div>
          </body>
        </html>
      `);
    } catch (error: any) {
      logger.error({ error }, 'Failed to handle GitHub App callback');
      logger.info({ installation_id: req.query.installation_id }, 'GitHub API repository fetch failure during callback');
      res.send(`
        <html>
          <head><title>GitHub Connection Failed</title></head>
          <body style="font-family: sans-serif; text-align: center; padding: 50px;">
            <h1 style="color: #ef4444;">GitHub Connection Failed</h1>
            <p>Please return to Orivox and try again.</p>
          </body>
        </html>
      `);
    }
  }

  /**
   * Lists all installations for the current organization.
   */
  async listInstallations(req: Request, res: Response) {
    try {
      const organizationId = req.user?.organizationId;
      
      const installations = await GitHubInstallation.find({ 
        organizationId,
        status: GitHubInstallationStatus.ACTIVE
      });

      return ApiResponse.success(res, { installations }, 'Installations retrieved');
    } catch (error: any) {
      logger.error({ error }, 'Failed to list GitHub App installations');
      return ApiResponse.error(res, error.message, null, 500);
    }
  }

  /**
   * Lists repositories accessible to a specific installation.
   */
  async listRepositories(req: Request, res: Response) {
    try {
      const organizationId = req.user?.organizationId;
      const { installationId } = req.params;

      const installation = await GitHubInstallation.findOne({
        _id: installationId,
        organizationId,
        status: GitHubInstallationStatus.ACTIVE
      });

      if (!installation) {
        return ApiResponse.error(res, 'Installation not found or inactive', null, 404);
      }

      const data = await githubClient.listInstallationRepositories(installation.installationId);
      
      const repositories = data.repositories.map((repo: any) => ({
        id: repo.id,
        name: repo.name,
        full_name: repo.full_name,
        private: repo.private,
        default_branch: repo.default_branch,
        html_url: repo.html_url,
        description: repo.description,
        owner: repo.owner.login,
        updated_at: repo.updated_at,
      }));

      return ApiResponse.success(res, { repositories }, 'Repositories retrieved');
    } catch (error: any) {
      logger.error({ error }, 'Failed to list repositories');
      return ApiResponse.error(res, error.message, null, 500);
    }
  }
  /**
   * Lists repositories for all active installations for the current organization.
   */
  async listAllRepositories(req: Request, res: Response) {
    try {
      const organizationId = req.user?.organizationId;
      
      const installations = await GitHubInstallation.find({ 
        organizationId,
        status: GitHubInstallationStatus.ACTIVE
      });

      const installationsWithRepos = await Promise.all(
        installations.map(async (installation) => {
          try {
            logger.info({ installationId: installation.installationId }, 'Starting repository fetch from GitHub');
            const data = await githubClient.listInstallationRepositories(installation.installationId);
            logger.info({ repositoryCount: data.repositories?.length }, 'GitHub API repository fetch completed');
            const repositories = data.repositories.map((repo: any) => ({
              id: repo.id,
              name: repo.name,
              full_name: repo.full_name,
              private: repo.private,
              default_branch: repo.default_branch,
              html_url: repo.html_url,
              description: repo.description,
              owner: repo.owner.login,
              updated_at: repo.updated_at,
            }));

            return {
              installationId: installation._id,
              githubAccountId: installation.githubAccountId,
              githubAccountLogin: installation.githubAccountLogin,
              githubAccountType: installation.githubAccountType,
              repositories,
            };
          } catch (err) {
            logger.warn({ err, installationId: installation.installationId }, 'Failed to list repositories for installation');
            // If the token expires or app is uninstalled on GitHub but not deleted in our DB
            return {
              installationId: installation._id,
              githubAccountId: installation.githubAccountId,
              githubAccountLogin: installation.githubAccountLogin,
              githubAccountType: installation.githubAccountType,
              repositories: [],
              error: 'Failed to access repositories from GitHub',
            };
          }
        })
      );

      return ApiResponse.success(res, { installations: installationsWithRepos }, 'Repositories retrieved');
    } catch (error: any) {
      logger.error({ error }, 'Failed to list all repositories');
      return ApiResponse.error(res, { code: 'GITHUB_REPOSITORY_FETCH_FAILED', message: 'Unable to fetch repositories from GitHub. Please try again.' }, null, 500);
    }
  }
  /**
   * Reconciles/links an existing GitHub installation to the current organization.
   * Useful when an installation was created but the callback failed or state was lost.
   */
  async reconcileInstallation(req: Request, res: Response) {
    try {
      const organizationId = req.user?.organizationId;
      const { installationId } = req.body;

      if (!installationId) {
        return ApiResponse.error(res, 'installationId is required', null, 400);
      }

      // Check if already claimed by this organization
      const existing = await GitHubInstallation.findOne({ installationId: Number(installationId) });
      if (existing && existing.organizationId.toString() !== organizationId) {
        return ApiResponse.error(res, 'Installation already claimed by another organization', null, 403);
      }

      // Verify the installation exists on GitHub and we have access
      let repos;
      try {
        const token = await githubClient.getInstallationToken(Number(installationId));
        repos = await githubClient.listInstallationRepositories(Number(installationId));
      } catch (err) {
        logger.error({ err, installationId }, 'Failed to verify installation ownership via GitHub');
        return ApiResponse.error(res, 'Could not verify installation with GitHub', null, 400);
      }

      let accountId = 0;
      let accountLogin = 'Unknown';
      let accountType = 'Unknown';

      if (repos.repositories && repos.repositories.length > 0) {
        const owner = repos.repositories[0].owner;
        accountId = owner.id;
        accountLogin = owner.login;
        accountType = owner.type;
      }

      const installation = await GitHubInstallation.findOneAndUpdate(
        { installationId: Number(installationId) },
        {
          organizationId,
          githubAccountId: accountId,
          githubAccountLogin: accountLogin,
          githubAccountType: accountType,
          status: GitHubInstallationStatus.ACTIVE,
        },
        { upsert: true, new: true }
      );

      return ApiResponse.success(res, { installation }, 'Installation reconciled successfully');
    } catch (error: any) {
      logger.error({ error }, 'Failed to reconcile installation');
      return ApiResponse.error(res, error.message, null, 500);
    }
  }
}

export const githubAppController = new GitHubAppController();
