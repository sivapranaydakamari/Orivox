import { logger } from '../../../config/logger';

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
