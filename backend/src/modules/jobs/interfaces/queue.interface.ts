import { JobType, JobStatus } from '../types/job.types';

export interface JobOptions {
  delay?: number;
  attempts?: number;
  backoff?: {
    type: 'fixed' | 'exponential';
    delay: number;
  };
  session?: unknown; // Mongoose ClientSession
}

export interface IJobContext {
  jobId: string;
  updateProgress: (progress: number) => Promise<void>;
}

export interface IQueueProvider {
  enqueue<T>(jobType: JobType, payload: T, options?: JobOptions): Promise<string>;
  getJobStatus(jobId: string): Promise<JobStatus>;
  getFailedJobs(jobType: JobType, limit?: number): Promise<JobStatus[]>;
  retryJob(jobId: string): Promise<boolean>;
  process<T>(jobType: JobType, concurrency: number, handler: (payload: T, context: IJobContext) => Promise<unknown>): void;
}
