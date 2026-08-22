import { logger } from '../../../config/logger';
import jwt from 'jsonwebtoken';
import { env } from '../../../config/env';

export class GitHubClient {
  private readonly baseUrl = 'https://api.github.com';

  private getHeaders(token?: string) {
    const headers: Record<string, string> = {
      Accept: 'application/vnd.github.v3+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    return headers;
  }

  /**
   * Helper to log GitHub rate limit headers from the response.
   */
  private logRateLimit(response: Response) {
    const remaining = response.headers.get('x-ratelimit-remaining');
    const reset = response.headers.get('x-ratelimit-reset');
    if (remaining && reset) {
      const resetTime = new Date(parseInt(reset) * 1000);
      logger.info({ remaining, resetTime }, 'GitHub API Rate Limit Info');
    }
  }

  /**
   * Generates a GitHub App JWT.
   */
  private generateAppJwt(): string {
    const appId = env.GITHUB_APP_ID;
    const privateKeyRaw = env.GITHUB_APP_PRIVATE_KEY;

    if (!appId || !privateKeyRaw) {
      throw new Error('GitHub App credentials are not configured');
    }

    // Handle escaped newlines from environment variables
    let privateKey = privateKeyRaw.replace(/\\n/g, '\n');
    
    // Strip leading/trailing quotes if accidentally included
    privateKey = privateKey.replace(/^["']|["']$/g, '');

    // Auto-fix if Render stripped actual newlines (user pasted as a single line)
    if (!privateKey.includes('\n')) {
      privateKey = privateKey
        .replace(/-----BEGIN RSA PRIVATE KEY-----/i, '-----BEGIN RSA PRIVATE KEY-----\n')
        .replace(/-----END RSA PRIVATE KEY-----/i, '\n-----END RSA PRIVATE KEY-----');
      
      const lines = privateKey.split('\n');
      if (lines.length === 3) {
         // Remove any stray spaces in the base64 body that might have been inserted when collapsing newlines
         lines[1] = lines[1].replace(/\s+/g, '');
         privateKey = lines.join('\n');
      }
    }

    const now = Math.floor(Date.now() / 1000);
    const payload = {
      iat: now - 60, // Issued at time, 60 seconds in the past to allow for clock drift
      exp: now + (10 * 60), // JWT expiration time (10 minute maximum)
      iss: appId, // GitHub App ID
    };

    return jwt.sign(payload, privateKey, { algorithm: 'RS256' });
  }

  /**
   * Fetches an installation access token for a specific installation ID.
   */
  async getInstallationToken(installationId: number): Promise<string> {
    const appJwt = this.generateAppJwt();
    const url = `${this.baseUrl}/app/installations/${installationId}/access_tokens`;
    
    const response = await fetch(url, {
      method: 'POST',
      headers: this.getHeaders(appJwt),
    });

    if (!response.ok) {
      const errorText = await response.text();
      logger.error({ installationId, status: response.status, errorText }, 'Failed to generate GitHub installation token');
      throw new Error(`GitHub API Error: Failed to generate installation token (Status: ${response.status})`);
    }

    const data = await response.json();
    return data.token;
  }

  /**
   * List accessible repositories for an installation.
   */
  async listInstallationRepositories(installationId: number) {
    const token = await this.getInstallationToken(installationId);
    // Note: The /installation/repositories endpoint requires the installation token.
    const url = `${this.baseUrl}/installation/repositories?per_page=100`;
    
    const response = await fetch(url, {
      headers: this.getHeaders(token),
    });

    this.logRateLimit(response);

    if (!response.ok) {
      throw new Error(`GitHub API Error: Failed to list installation repositories (Status: ${response.status})`);
    }

    return await response.json();
  }

  /**
   * Validate if the provided token has access.
   */
  async validateToken(token: string): Promise<boolean> {
    try {
      const response = await fetch(`${this.baseUrl}/user`, {
        headers: this.getHeaders(token),
      });
      this.logRateLimit(response);
      return response.ok;
    } catch (error) {
      logger.error({ error }, 'GitHub API: Token validation failed');
      return false;
    }
  }

  /**
   * Retrieve metadata for a specific repository.
   */
  async getRepositoryMetadata(token: string, owner: string, repo: string) {
    const response = await fetch(`${this.baseUrl}/repos/${owner}/${repo}`, {
      headers: this.getHeaders(token),
    });

    this.logRateLimit(response);

    if (!response.ok) {
      throw new Error(`GitHub API Error: Failed to fetch repository metadata (Status: ${response.status})`);
    }

    return await response.json();
  }

  /**
   * List Pull Requests from a repository.
   */
  async listPullRequests(token: string, owner: string, repo: string, perPage: number = 30, page: number = 1, since?: Date) {
    // Currently fetching only 'closed' PRs to simulate merged ones or we can fetch 'all'
    // For knowledge extraction, merged PRs are most valuable.
    // If since is provided, we fetch PRs updated after the specified date.
    
    // GitHub PRs list API doesn't support 'since' natively like issues, so we sort by updated
    const url = `${this.baseUrl}/repos/${owner}/${repo}/pulls?state=closed&sort=updated&direction=desc&per_page=${perPage}&page=${page}`;
    
    const response = await fetch(url, {
      headers: this.getHeaders(token),
    });

    this.logRateLimit(response);

    if (!response.ok) {
      throw new Error(`GitHub API Error: Failed to list PRs (Status: ${response.status})`);
    }

    const prs = await response.json();
    
    if (since) {
      return prs.filter((pr: { updated_at: string }) => new Date(pr.updated_at) > since);
    }
    
    return prs;
  }

  /**
   * Get specific pull request details.
   */
  async getPullRequestDetails(token: string, owner: string, repo: string, pullNumber: number) {
    const response = await fetch(`${this.baseUrl}/repos/${owner}/${repo}/pulls/${pullNumber}`, {
      headers: this.getHeaders(token),
    });

    this.logRateLimit(response);

    if (!response.ok) {
      throw new Error(`GitHub API Error: Failed to fetch PR #${pullNumber} (Status: ${response.status})`);
    }

    return await response.json();
  }

  /**
   * Fetch Git Tree for a repository branch.
   */
  async getGitTree(token: string, owner: string, repo: string, treeSha: string, recursive: boolean = true) {
    const url = `${this.baseUrl}/repos/${owner}/${repo}/git/trees/${treeSha}${recursive ? '?recursive=1' : ''}`;
    const response = await fetch(url, { headers: this.getHeaders(token) });
    this.logRateLimit(response);

    if (!response.ok) {
      throw new Error(`GitHub API Error: Failed to fetch Git Tree (Status: ${response.status})`);
    }

    return await response.json();
  }

  /**
   * Fetch file blob contents (Base64 decoded).
   */
  async getFileBlob(token: string, owner: string, repo: string, fileSha: string): Promise<string> {
    const url = `${this.baseUrl}/repos/${owner}/${repo}/git/blobs/${fileSha}`;
    const response = await fetch(url, { headers: this.getHeaders(token) });
    this.logRateLimit(response);

    if (!response.ok) {
      throw new Error(`GitHub API Error: Failed to fetch blob (Status: ${response.status})`);
    }

    const data = await response.json();
    if (data.encoding === 'base64') {
      return Buffer.from(data.content, 'base64').toString('utf-8');
    }
    return data.content;
  }

  /**
   * Fetch specific commit details.
   */
  async getCommit(token: string, owner: string, repo: string, commitSha: string) {
    const url = `${this.baseUrl}/repos/${owner}/${repo}/commits/${commitSha}`;
    const response = await fetch(url, { headers: this.getHeaders(token) });
    this.logRateLimit(response);

    if (!response.ok) {
      throw new Error(`GitHub API Error: Failed to fetch commit (Status: ${response.status})`);
    }

    return await response.json();
  }
}

export const githubClient = new GitHubClient();
