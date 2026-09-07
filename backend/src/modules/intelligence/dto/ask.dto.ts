export enum AskScope {
  CURRENT_PROJECT = 'CURRENT_PROJECT',
  ALL_PROJECTS = 'ALL_PROJECTS',
}

export interface AskDto {
  scope?: AskScope;
  projectId?: string;
  question: string;
}
