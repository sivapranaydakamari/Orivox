import { queueService } from '../queue.service';
import { JobType } from '../types/job.types';
import { logger } from '../../../config/logger';
import { repositoryRepository } from '../../repository/repository/repository.repository';
import { sourceRegistry } from '../../integration/registry/source.registry';
import { DocumentSourceType } from '../../document/model/document.model';

export interface WebhookJobPayload {
  repositoryId: string;
  event: string;
  payload: any;
  deliveryId: string;
}

export class WebhookWorker {
  constructor() {
    queueService.process<WebhookJobPayload>(
      JobType.PROCESS_GITHUB_WEBHOOK,
      2,
      async (jobPayload, context) => {
        const { repositoryId, event, payload, deliveryId } = jobPayload;
        logger.info({ jobId: context.jobId, repositoryId, event, deliveryId }, 'Processing GITHUB_WEBHOOK job');

        await context.updateProgress(10);

        const repository = await repositoryRepository.findById(repositoryId);
        if (!repository) {
          throw new Error(`Repository not found: ${repositoryId}`);
        }

        // Only GitHub is supported for webhooks right now
        if (repository.provider.toUpperCase() !== 'GITHUB') {
          logger.warn({ provider: repository.provider }, 'Webhook received for non-GitHub provider');
          return { success: false, reason: 'Unsupported provider' };
        }

        const provider = sourceRegistry.getProvider(DocumentSourceType.GITHUB);

        await context.updateProgress(30);

        // Delegate the actual parsing and ingestion to the provider since it knows how to handle 
        // GitHub specific payloads and use the ingestionService properly.
        if (typeof (provider as any).processWebhook === 'function') {
          await (provider as any).processWebhook({
            event,
            payload,
            repository,
          });
        } else {
          logger.error('GitHubProvider does not implement processWebhook()');
          throw new Error('GitHubProvider does not implement processWebhook()');
        }

        await context.updateProgress(100);
        return { success: true, event };
      }
    );
  }
}

export const webhookWorker = new WebhookWorker();
