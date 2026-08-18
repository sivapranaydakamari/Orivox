import { queueService } from '../queue.service';
import { JobType } from '../types/job.types';
import { logger } from '../../../config/logger';
import { env } from '../../../config/env';
import { MistralClient } from '../../intelligence/clients/mistral.client';
import { AIExtractionService } from '../../intelligence/services/ai-extraction.service';

const mistralClient = new MistralClient({ apiKey: env.MISTRAL_API_KEY });
const aiExtractionService = new AIExtractionService(mistralClient);

export interface ExtractJobPayload {
  documentId: string;
}

export class ExtractionWorker {
  constructor() {
    queueService.process<ExtractJobPayload>(
      JobType.EXTRACT_DOCUMENT,
      10, // Higher concurrency for extraction
      async (payload, context) => {
        logger.info({ jobId: context.jobId, documentId: payload.documentId }, 'Processing EXTRACT_DOCUMENT job');
        await context.updateProgress(10);
        
        // 1. Fetch Document and Redact Secrets
        const document = await import('../../document/model/document.model').then(m => m.DocumentModel.findById(payload.documentId));
        if (document && document.rawContent) {
          // Very basic secret scanning (tokens, private keys, auth headers)
          const redactedContent = document.rawContent
            .replace(/([a-zA-Z0-9_-]*_)?(secret|token|key|password|apiKey|api_key|pwd)[-_:= ]+['"]?[a-zA-Z0-9_.-]{10,}['"]?/gi, '[REDACTED SECRET]')
            .replace(/Bearer [a-zA-Z0-9_.-]+/g, 'Bearer [REDACTED]')
            .replace(/-----BEGIN (.*) PRIVATE KEY-----[\s\S]*?-----END (.*) PRIVATE KEY-----/g, '[REDACTED PRIVATE KEY]');
          
          if (redactedContent !== document.rawContent) {
            logger.warn({ documentId: payload.documentId }, 'Secret Scanner detected and redacted sensitive information before extraction');
            document.rawContent = redactedContent;
            await document.save();
          }
        }

        // 2. Use the AIExtractionService which handles parsing, prompt building, LLM execution, and KnowledgeRecord creation.
        // It has internal idempotency (skips if DocumentStatus !== PENDING).
        const record = await aiExtractionService.extractDocument(payload.documentId);
        
        await context.updateProgress(90);

        if (record) {
          logger.info({ documentId: payload.documentId, recordId: record._id }, 'Enqueuing GENERATE_EMBEDDING job');
          await queueService.enqueue(JobType.GENERATE_EMBEDDING, { recordId: record._id.toString() });
        } else {
          logger.info({ documentId: payload.documentId }, 'Skipped enqueuing GENERATE_EMBEDDING (record not created/updated)');
        }
        
        await context.updateProgress(100);
        return { success: true, documentId: payload.documentId };
      }
    );
  }
}

export const extractionWorker = new ExtractionWorker();
