import { queueService } from '../queue.service';
import { JobType } from '../types/job.types';
import { logger } from '../../../config/logger';
import { env } from '../../../config/env';
import { EmbeddingClient } from '../../intelligence/clients/embedding.client';
import { EmbeddingService } from '../../intelligence/services/embedding.service';

const embeddingClient = new EmbeddingClient({ apiKey: env.MISTRAL_API_KEY });
const embeddingService = new EmbeddingService(embeddingClient);

export interface EmbedJobPayload {
  recordId: string;
}

export class EmbeddingWorker {
  constructor() {
    queueService.process<EmbedJobPayload>(
      JobType.GENERATE_EMBEDDING,
      5,
      async (payload, context) => {
        logger.info({ jobId: context.jobId, recordId: payload.recordId }, 'Processing GENERATE_EMBEDDING job');
        await context.updateProgress(10);

        // The EmbeddingService internally handles idempotency: it fetches the record,
        // checks if the status is PENDING or FAILED, skips if not, calls the mistral API,
        // and updates the KnowledgeRecord in MongoDB.
        await embeddingService.embedKnowledgeRecord(payload.recordId);

        await context.updateProgress(100);
        return { success: true, recordId: payload.recordId };
      }
    );
  }
}

export const embeddingWorker = new EmbeddingWorker();
