export interface CreateRepositoryDto {
  organizationId: string;
  projectId: string;
  repositoryUrl?: string;
  repositoryName: string;
  provider?: string;
  
  // GitHub App specific
  githubInstallationId?: string;
  githubRepositoryId?: number;
  githubRepositoryFullName?: string;
  sourceConfiguration?: {
    code: boolean;
    docs: boolean;
    prs: boolean;
  };
}

export interface UpdateRepositoryDto {
  [key: string]: unknown;
  isActive?: boolean;
}
