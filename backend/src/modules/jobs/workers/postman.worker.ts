import { queueService } from '../queue.service';
import { JobType } from '../types/job.types';
import { logger } from '../../../config/logger';
import { documentService } from '../../document/service/document.service';
import { postmanIngestionService } from '../../integration/services/postman-ingestion.service';

export interface PostmanWebhookJobPayload {
  documentId: string;
  event: string;
  payload: any;
}

export class PostmanWorker {
  constructor() {
    queueService.process<PostmanWebhookJobPayload>(
      JobType.PROCESS_POSTMAN_WEBHOOK,
      2,
      async (jobPayload, context) => {
        const { documentId, event, payload } = jobPayload;
        logger.info({ jobId: context.jobId, documentId, event }, 'Processing POSTMAN_WEBHOOK job');

        await context.updateProgress(10);

        const document = await documentService.getDocumentById(documentId);
        if (!document) {
          throw new Error(`Document not found: ${documentId}`);
        }

        await context.updateProgress(30);

        if (event === 'collection.updated' || event === 'synthetic.update') {
          // Re-ingest the collection
          // The payload is expected to be the raw Postman Collection JSON object
          logger.info({ documentId }, 'Re-ingesting Postman collection from webhook');
          
          // Re-use postmanIngestionService's process method to get endpoints
          // Wait, postmanIngestionService.ingestCollection creates a NEW document.
          // But we want to UPSERT the current document.
          // For now, we update the existing document's rawContent and re-queue extraction.
          
          const collectionJson = typeof payload === 'string' ? payload : JSON.stringify(payload);
          let parsedCollection;
          try {
            parsedCollection = JSON.parse(collectionJson);
          } catch (error) {
            throw new Error('Invalid Postman Collection JSON in webhook payload');
          }

          if (!parsedCollection.info || !parsedCollection.info.name) {
            throw new Error('Invalid Postman Collection format. Missing info.name.');
          }

          // Use a hack to call private method processCollection
          const processedContent = (postmanIngestionService as any).processCollection(parsedCollection);
          
          const { documentRepository } = await import('../../document/repository/document.repository');
          await documentRepository.update(documentId, {
            rawContent: JSON.stringify(processedContent),
            status: 'PENDING' as any,
          });

          await queueService.enqueue(JobType.EXTRACT_DOCUMENT, {
            documentId,
            projectId: document.projectId.toString(),
            organizationId: document.organizationId.toString(),
          });

        } else {
          logger.warn({ event }, 'Unsupported Postman webhook event');
        }

        await context.updateProgress(100);
        return { success: true, event };
      }
    );
  }
}

export const postmanWorker = new PostmanWorker();
