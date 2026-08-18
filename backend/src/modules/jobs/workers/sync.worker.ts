import { queueService } from '../queue.service';
import { JobType } from '../types/job.types';
import { syncManager } from '../../integration/services/sync.manager';
import { logger } from '../../../config/logger';

export interface SyncJobPayload {
  repositoryId: string;
  providerToken?: string;
}

export class SyncWorker {
  constructor() {
    queueService.process<SyncJobPayload>(
      JobType.SYNC_REPOSITORY,
      5,
      async (payload, context) => {
        logger.info({ jobId: context.jobId, repositoryId: payload.repositoryId }, 'Processing SYNC_REPOSITORY job');
        await context.updateProgress(10); // Sync started

        const documentIds = await syncManager.startSync(payload.repositoryId, payload.providerToken, context.jobId);
        
        await context.updateProgress(80); // Sync complete, enqueueing extractions

        for (const docId of documentIds) {
          await queueService.enqueue(JobType.EXTRACT_DOCUMENT, { documentId: docId.toString() });
        }
        
        await context.updateProgress(100);
        return { success: true, repositoryId: payload.repositoryId, extractedCount: documentIds.length };
      }
    );
  }
}

// Instantiate to register the worker
export const syncWorker = new SyncWorker();
