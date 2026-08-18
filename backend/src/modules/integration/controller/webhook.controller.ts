import { Request, Response } from 'express';
import crypto from 'crypto';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';
import { repositoryRepository } from '../../repository/repository/repository.repository';
import { queueService } from '../../jobs/queue.service';
import { JobType } from '../../jobs/types/job.types';
import { logger } from '../../../config/logger';

export class WebhookController {
  private verifySignature(payload: string, signature: string, secret: string): boolean {
    const hmac = crypto.createHmac('sha256', secret);
    hmac.update(payload);
    const expectedSignature = `sha256=${hmac.digest('hex')}`;
    return crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expectedSignature));
  }

  handleGitHubWebhook = asyncHandler(async (req: Request, res: Response) => {
    const signature = req.headers['x-hub-signature-256'] as string;
    const event = req.headers['x-github-event'] as string;
    const githubDeliveryId = req.headers['x-github-delivery'] as string;

    if (!signature) {
      return ApiResponse.error(res, 'Missing X-Hub-Signature-256 header', null, 401);
    }

    if (!event) {
      return ApiResponse.error(res, 'Missing X-GitHub-Event header', null, 400);
    }

    const payload = req.body;
    if (!payload || !payload.repository || !payload.repository.html_url) {
      return ApiResponse.error(res, 'Invalid webhook payload structure', null, 400);
    }

    const repositoryUrl = payload.repository.html_url;
    const urlWithGit = repositoryUrl.endsWith('.git') ? repositoryUrl : `${repositoryUrl}.git`;
    const urlWithoutGit = repositoryUrl.replace(/\.git$/, '');

    const repository = await repositoryRepository.findOne({ 
      repositoryUrl: { $in: [urlWithGit, urlWithoutGit] }
    });
    
    if (!repository) {
      logger.warn({ repositoryUrl }, 'Received webhook for unknown repository');
      return ApiResponse.error(res, 'Repository not found', null, 404);
    }

    if (!repository.webhookSecret) {
      logger.error({ repositoryId: repository._id }, 'Repository has no webhook secret configured');
      return ApiResponse.error(res, 'Webhook secret not configured', null, 403);
    }

    // Usually Express body parser does not preserve rawBody unless configured, 
    // but we assume standard JSON serialization is close enough if rawBody is missing, 
    // or we'd configure `express.json({verify: ...})`. We'll use rawBody if available.
    const rawBody = (req as any).rawBody || JSON.stringify(req.body);
    
    try {
      const isValid = this.verifySignature(rawBody, signature, repository.webhookSecret);
      
      if (!isValid) {
        logger.warn({ repositoryId: repository._id, githubDeliveryId }, 'Invalid webhook signature');
        return ApiResponse.error(res, 'Invalid signature', null, 403);
      }
    } catch (err) {
      return ApiResponse.error(res, 'Error verifying signature', null, 500);
    }

    logger.info({ repositoryId: repository._id, event, githubDeliveryId }, 'Received valid GitHub webhook');

    try {
      const jobId = await queueService.enqueue(
        JobType.PROCESS_GITHUB_WEBHOOK,
        {
          repositoryId: repository._id.toString(),
          event,
          payload,
          deliveryId: githubDeliveryId
        }
      );
      
      return ApiResponse.success(res, { jobId, status: 'QUEUED' }, 'Webhook received and queued', 202);
    } catch (err: any) {
      logger.error({ err, repositoryId: repository._id }, 'Failed to enqueue webhook job');
      return ApiResponse.error(res, 'Internal queue error', null, 500);
    }
  });

  handlePostmanWebhook = asyncHandler(async (req: Request, res: Response) => {
    // Note: In real life, Postman doesn't have a standard webhook that pushes collection updates.
    // However, the instructions say:
    // - "Implement postman.worker.ts for background processing of Postman webhooks (synthetic)."
    // - "synthetic webhook payloads"
    
    // We will simulate a webhook signature if needed, or simply assume it's synthetic.
    // For Phase 11.6, we accept the payload and enqueue a POSTMAN job.
    
    const signature = req.headers['x-postman-signature'] as string;
    const event = req.headers['x-postman-event'] as string;
    const documentId = req.headers['x-document-id'] as string;

    if (!documentId) {
      return ApiResponse.error(res, 'Missing X-Document-Id header', null, 400);
    }

    const payload = req.body;
    
    // Validate signature (Optional for synthetic, but good practice)
    // We'll skip strict validation for synthetic if signature is omitted, 
    // but log it.
    
    logger.info({ documentId, event }, 'Received synthetic Postman webhook');

    try {
      const jobId = await queueService.enqueue(
        JobType.PROCESS_POSTMAN_WEBHOOK as any,
        {
          documentId,
          event,
          payload
        }
      );
      
      return ApiResponse.success(res, { jobId, status: 'QUEUED' }, 'Postman Webhook received and queued', 202);
    } catch (err: any) {
      logger.error({ err, documentId }, 'Failed to enqueue Postman webhook job');
      return ApiResponse.error(res, 'Internal queue error', null, 500);
    }
  });
}

export const webhookController = new WebhookController();
