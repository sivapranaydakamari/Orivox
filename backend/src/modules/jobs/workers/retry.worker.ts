import { queueService } from '../queue.service';
import { JobType } from '../types/job.types';
import { logger } from '../../../config/logger';

export interface RetryJobPayload {
  failedJobId: string;
  originalJobType: JobType;
  payload: unknown;
}

export class RetryWorker {
  constructor() {
    queueService.process<RetryJobPayload>(
      JobType.RETRY_FAILED_DOCUMENT,
      2,
      async (payload, context) => {
        logger.info({ jobId: context.jobId, originalJob: payload.failedJobId }, 'Processing RETRY_FAILED_DOCUMENT job');
        await context.updateProgress(10);
        
        // Push the original payload back to its original queue
        await queueService.enqueue(payload.originalJobType, payload.payload);
        
        await context.updateProgress(100);
        return { success: true, retriedJobType: payload.originalJobType };
      }
    );
  }
}

export const retryWorker = new RetryWorker();
