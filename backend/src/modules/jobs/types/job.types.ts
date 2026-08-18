export enum JobType {
  SYNC_REPOSITORY = 'SYNC_REPOSITORY',
  EXTRACT_DOCUMENT = 'EXTRACT_DOCUMENT',
  GENERATE_EMBEDDING = 'GENERATE_EMBEDDING',
  RETRY_FAILED_DOCUMENT = 'RETRY_FAILED_DOCUMENT',
  REINDEX_PROJECT = 'REINDEX_PROJECT',
  PROCESS_GITHUB_WEBHOOK = 'PROCESS_GITHUB_WEBHOOK',
  PROCESS_POSTMAN_WEBHOOK = 'PROCESS_POSTMAN_WEBHOOK',
}

export interface JobStatus {
  id: string;
  type: string;
  status: 'pending' | 'active' | 'completed' | 'failed' | 'delayed' | 'unknown';
  progress: number;
  queuedAt?: Date;
  startedAt?: Date;
  completedAt?: Date;
  duration?: number;
  retries: number;
  error?: string;
  result?: unknown;
}
