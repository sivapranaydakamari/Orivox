import { Router } from 'express';
import { webhookController } from '../controller/webhook.controller';

const router = Router();

// Endpoint for receiving GitHub webhooks
router.post('/github/webhook', webhookController.handleGitHubWebhook);

// Endpoint for receiving Postman webhooks
router.post('/postman/webhook', webhookController.handlePostmanWebhook);

export default router;
