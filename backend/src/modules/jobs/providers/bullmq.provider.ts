import { IQueueProvider, JobOptions, IJobContext } from '../interfaces/queue.interface';
import { JobType, JobStatus } from '../types/job.types';
import { logger } from '../../../config/logger';

export class BullMqProvider implements IQueueProvider {
  private readonly handlers: Map<string, (payload: any, context: IJobContext) => Promise<any>> = new Map();

  constructor() {
    logger.info('Initialized Mock In-Memory BullMqProvider (No Redis)');
  }

  async enqueue<T>(jobType: JobType, payload: T, options?: JobOptions): Promise<string> {
    const jobId = 'mock_job_' + Date.now();
    
    // Execute asynchronously in background to mimic queue
    setTimeout(async () => {
      const handler = this.handlers.get(jobType);
      if (handler) {
        try {
          const context: IJobContext = {
            jobId,
            updateProgress: async () => {},
          };
          await handler(payload, context);
          logger.info(`Mock job ${jobId} of type ${jobType} completed`);
        } catch (err) {
          logger.error({ err }, `Mock job ${jobId} of type ${jobType} failed`);
        }
      }
    }, 100);

    return jobId;
  }

  async getJobStatus(jobId: string): Promise<JobStatus> {
    return {
      id: jobId,
      type: 'UNKNOWN',
      status: 'completed',
      progress: 100,
      retries: 0,
    } as any;
  }

  async getFailedJobs(jobType: JobType, limit = 50): Promise<JobStatus[]> {
    return [];
  }

  async retryJob(jobId: string): Promise<boolean> {
    return false;
  }

  process<T>(jobType: JobType, concurrency: number, handler: (payload: T, context: IJobContext) => Promise<any>): void {
    this.handlers.set(jobType, handler);
    logger.info(`Initialized Mock Worker for ${jobType}`);
  }
}
