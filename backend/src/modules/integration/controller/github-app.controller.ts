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
      const organizationId = (req as any).organizationId;
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
      const { installation_id, setup_action, state } = req.query;

      if (!installation_id || setup_action !== 'install') {
        return res.status(400).send('Invalid callback parameters');
      }

      let organizationId: string;
      try {
        const decodedState = JSON.parse(Buffer.from(state as string, 'base64').toString('utf-8'));
        organizationId = decodedState.organizationId;
      } catch (err) {
        return res.status(400).send('Invalid state parameter');
      }

      if (!organizationId) {
        return res.status(400).send('Missing organization context');
      }

      // We need to fetch details about this installation from GitHub using our App JWT
      const token = await githubClient.getInstallationToken(Number(installation_id));
      
      // Fetch the installation details directly (optional, but good to store account info)
      // Since we just need to record it, we can actually just query the github api
      // However, we don't strictly need it if we just want to save the installationId
      // Let's at least get the repositories to get the owner name
      const repos = await githubClient.listInstallationRepositories(Number(installation_id));
      
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

      // Return a simple HTML page that asks the user to close the window
      res.send(`
        <html>
          <head><title>GitHub Connected</title></head>
          <body style="font-family: sans-serif; text-align: center; padding: 50px;">
            <h2>GitHub App Successfully Installed! 🎉</h2>
            <p>Orivox is now connected. You may close this window and return to the application.</p>
            <script>
              setTimeout(() => {
                window.close();
              }, 3000);
            </script>
          </body>
        </html>
      `);
    } catch (error: any) {
      logger.error({ error }, 'Failed to handle GitHub App callback');
      res.status(500).send('An error occurred during GitHub App installation.');
    }
  }

  /**
   * Lists all installations for the current organization.
   */
  async listInstallations(req: Request, res: Response) {
    try {
      const organizationId = (req as any).organizationId;
      
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
      const organizationId = (req as any).organizationId;
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
}

export const githubAppController = new GitHubAppController();
