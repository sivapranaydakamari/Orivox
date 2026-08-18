import { ISourceProvider } from '../interfaces/source-provider.interface';
import { IRawArtifact } from '../models/raw-artifact.model';
import { GitHubClient } from '../clients/github.client';
import { DocumentSourceType } from '../../document/model/document.model';
import { logger } from '../../../config/logger';
import { IRepository } from '../../repository/model/repository.model';
import { ingestionService } from '../services/ingestion.service';

export class GitHubProvider implements ISourceProvider {
  constructor(private readonly client: GitHubClient) {}

  async validateConnection(connectionData: Record<string, unknown>): Promise<boolean> {
    const token = connectionData.token as string;
    if (!token) return false;
    return await this.client.validateToken(token);
  }

  async fetchArtifacts(filterData: Record<string, unknown>): Promise<IRawArtifact[]> {
    throw new Error('NotImplementedError: Use sync or processWebhook');
  }

  async fetchArtifactById(_externalId: string): Promise<IRawArtifact> {
    throw new Error('NotImplementedError');
  }

  private categorizeFile(path: string): string {
    const lower = path.toLowerCase();
    if (lower.includes('readme') || lower.endsWith('.md') || lower.endsWith('.mdx')) {
      return 'DOCUMENTATION';
    }
    if (lower.includes('openapi') || lower.includes('swagger') || lower.endsWith('spec.json') || lower.endsWith('spec.yaml')) {
      return 'API_SPEC';
    }
    return 'SOURCE_FILE';
  }

  private isExcluded(path: string): boolean {
    const lower = path.toLowerCase();
    const exclusions = [
      'node_modules', 'dist', 'build', 'coverage', '.git', '.dart_tool', 
      'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', '.jpg', '.jpeg', 
      '.png', '.gif', '.mp4', '.mp3', '.pdf', '.zip', '.tar.gz'
    ];
    return exclusions.some(ex => lower.includes(ex));
  }

  async sync(syncState: Record<string, unknown>): Promise<{ artifacts: IRawArtifact[]; nextSyncState: Record<string, unknown> }> {
    const { owner, repo, token, lastProcessedCommitSha, organizationId, projectId, repositoryId } = syncState;

    if (!owner || !repo || !token) {
      throw new Error('GitHubProvider: Missing required sync parameters.');
    }

    logger.info({ owner, repo }, 'GitHubProvider: Starting sync');
    const artifacts: IRawArtifact[] = [];
    let nextCommitSha = lastProcessedCommitSha as string;

    try {
      // Very basic implementation: just sync the main branch tree.
      // In a real system, you'd find the default branch dynamically and fetch the tree.
      const branchInfo = await this.client.getRepositoryMetadata(token as string, owner as string, repo as string);
      const defaultBranch = branchInfo.default_branch || 'main';

      if (!lastProcessedCommitSha) {
        logger.info('Performing initial full tree sync');
        const tree = await this.client.getGitTree(token as string, owner as string, repo as string, defaultBranch, true);
        
        // Save the commit sha of the tree
        nextCommitSha = tree.sha;

        for (const item of tree.tree) {
          if (item.type === 'blob' && !this.isExcluded(item.path)) {
            // Fetch content only for non-excluded files. 
            // In a production system, doing this in parallel or async batching is required.
            // For now we will fetch a few to demonstrate functionality, otherwise we hit rate limits instantly.
            if (artifacts.length > 50) break; // Limit for demo safety

            try {
              const content = await this.client.getFileBlob(token as string, owner as string, repo as string, item.sha);
              const category = this.categorizeFile(item.path);

              artifacts.push({
                sourceType: DocumentSourceType.GITHUB,
                externalId: `github:${owner}/${repo}:file:${defaultBranch}:${item.path}`,
                title: `${item.path}`,
                content: content,
                metadata: { category, path: item.path, sha: item.sha, branch: defaultBranch },
                importedAt: new Date(),
                organizationId: organizationId as string,
                projectId: projectId as string,
                repositoryId: repositoryId as string,
              });
            } catch (err) {
              logger.warn({ path: item.path }, 'Failed to fetch blob');
            }
          }
        }
      } else {
        logger.info('Incremental sync should be implemented here (e.g. comparing commits)');
        // Would fetch commits between lastProcessedCommitSha and HEAD, and find changed files.
      }
    } catch (error) {
      logger.error({ error, owner, repo }, 'GitHubProvider: Sync failed');
      throw error;
    }

    return {
      artifacts,
      nextSyncState: {
        ...syncState,
        lastProcessedCommitSha: nextCommitSha,
      },
    };
  }

  /**
   * Process a GitHub Webhook Event
   */
  async processWebhook(context: { event: string, payload: any, repository: IRepository }): Promise<void> {
    const { event, payload, repository } = context;
    const token = repository.providerToken;

    if (!token) {
      logger.error('No provider token found for repository webhook processing');
      return;
    }

    const owner = payload.repository?.owner?.login;
    const repo = payload.repository?.name;

    if (event === 'push') {
      await this.handlePushEvent(payload, owner, repo, token, repository);
    } else if (event === 'pull_request') {
      await this.handlePullRequestEvent(payload, owner, repo, token, repository);
    } else {
      logger.info({ event }, 'Ignoring unsupported GitHub webhook event');
    }
  }

  private async handlePushEvent(payload: any, owner: string, repo: string, token: string, repository: IRepository) {
    const branch = payload.ref.replace('refs/heads/', '');
    const added = payload.commits.flatMap((c: any) => c.added);
    const modified = payload.commits.flatMap((c: any) => c.modified);
    const removed = payload.commits.flatMap((c: any) => c.removed);

    logger.info({ added: added.length, modified: modified.length, removed: removed.length }, 'Processing Push Event');

    const externalIdsToDelete = removed.map((path: string) => `github:${owner}/${repo}:file:${branch}:${path}`);
    if (externalIdsToDelete.length > 0) {
      await ingestionService.deleteArtifacts(externalIdsToDelete, repository.projectId.toString());
      repository.filesDeleted = (repository.filesDeleted || 0) + externalIdsToDelete.length;
    }

    const filesToIngest = [...new Set([...added, ...modified])] as string[];
    const artifacts: IRawArtifact[] = [];

    for (const path of filesToIngest) {
      if (this.isExcluded(path)) continue;

      try {
        // Find the blob sha for this path in the latest commit tree.
        // For simplicity in webhook, we might just fetch the file directly via raw URL or API.
        // GitHub API: GET /repos/{owner}/{repo}/contents/{path}
        const response = await fetch(`https://api.github.com/repos/${owner}/${repo}/contents/${path}?ref=${branch}`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Accept': 'application/vnd.github.v3+json',
            'X-GitHub-Api-Version': '2022-11-28',
          }
        });

        if (!response.ok) {
          logger.warn({ path }, 'Failed to fetch file content during push processing');
          continue;
        }

        const data = await response.json();
        const content = Buffer.from(data.content, 'base64').toString('utf-8');
        const category = this.categorizeFile(path);

        artifacts.push({
          sourceType: DocumentSourceType.GITHUB,
          externalId: `github:${owner}/${repo}:file:${branch}:${path}`,
          title: path,
          content: content,
          metadata: { category, path, sha: data.sha, branch },
          importedAt: new Date(),
          organizationId: repository.organizationId.toString(),
          projectId: repository.projectId.toString(),
          repositoryId: repository._id.toString(),
        });

      } catch (err) {
        logger.error({ err, path }, 'Error fetching file during push');
      }
    }

    if (artifacts.length > 0) {
      await ingestionService.bulkIngestArtifacts(artifacts);
      repository.filesAdded = (repository.filesAdded || 0) + added.length;
      repository.filesModified = (repository.filesModified || 0) + modified.length;
    }

    repository.lastProcessedCommitSha = payload.after;
    await repository.save();
  }

  private async handlePullRequestEvent(payload: any, owner: string, repo: string, token: string, repository: IRepository) {
    const pr = payload.pull_request;
    const action = payload.action;

    logger.info({ prNumber: pr.number, action }, 'Processing Pull Request Event');

    const externalId = `github:${owner}/${repo}:pr:${pr.number}`;

    if (action === 'closed' || action === 'opened' || action === 'synchronize' || action === 'edited') {
      const artifact: IRawArtifact = {
        sourceType: DocumentSourceType.GITHUB,
        externalId,
        title: `PR #${pr.number}: ${pr.title}`,
        content: pr.body || 'No description provided.',
        metadata: {
          category: 'PULL_REQUEST',
          prNumber: pr.number,
          state: pr.state,
          author: pr.user.login,
          url: pr.html_url,
        },
        importedAt: new Date(),
        organizationId: repository.organizationId.toString(),
        projectId: repository.projectId.toString(),
        repositoryId: repository._id.toString(),
      };

      await ingestionService.bulkIngestArtifacts([artifact]);
      repository.prsProcessed = (repository.prsProcessed || 0) + 1;
      await repository.save();
    }
  }

  async disconnect(): Promise<void> {
    logger.info('GitHubProvider disconnected.');
  }
}
