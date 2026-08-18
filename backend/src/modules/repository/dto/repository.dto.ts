export interface CreateRepositoryDto {
  organizationId: string;
  projectId: string;
  repositoryUrl: string;
  repositoryName: string;
  provider?: string;
}

export interface UpdateRepositoryDto {
  [key: string]: unknown;
  isActive?: boolean;
}
