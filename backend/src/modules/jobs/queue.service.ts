import { IQueueProvider, JobOptions, IJobContext } from './interfaces/queue.interface';
import { BullMqProvider } from './providers/bullmq.provider';
import { ClientSession } from 'mongoose';
import { JobType, JobStatus } from './types/job.types';
import { outboxEventRepository } from './repository/outbox-event.repository';

export class QueueService {
  private provider: IQueueProvider;

  constructor(provider: IQueueProvider) {
    this.provider = provider;
  }

  async enqueue<T>(jobType: JobType, payload: T, options?: JobOptions): Promise<string> {
    if (options?.session) {
      const event = await outboxEventRepository.createEvent(
        {
          jobType,
          payload: payload as Record<string, unknown>,
        },
        options.session as ClientSession
      );
      return event._id.toString();
    }
    return this.provider.enqueue(jobType, payload, options);
  }

  async getJobStatus(jobId: string): Promise<JobStatus> {
    return this.provider.getJobStatus(jobId);
  }

  async getFailedJobs(jobType: JobType, limit?: number): Promise<JobStatus[]> {
    return this.provider.getFailedJobs(jobType, limit);
  }

  async retryJob(jobId: string): Promise<boolean> {
    return this.provider.retryJob(jobId);
  }

  process<T>(jobType: JobType, concurrency: number, handler: (payload: T, context: IJobContext) => Promise<unknown>): void {
    this.provider.process(jobType, concurrency, handler);
  }
}

// Singleton instantiation
export const queueService = new QueueService(new BullMqProvider());
