export interface CreateOrganizationDto {
  name: string;
  slug: string;
}

export interface UpdateOrganizationDto {
  [key: string]: unknown;
  name?: string;
}
