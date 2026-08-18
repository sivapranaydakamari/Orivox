export interface CreateProjectDto {
  name: string;
  description?: string;
  organizationId: string;
}

export interface UpdateProjectDto {
  [key: string]: unknown;
  name?: string;
  description?: string;
}
