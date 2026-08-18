import { Router } from 'express';
import { webhookController } from '../controller/webhook.controller';

const router = Router();

// Endpoint for receiving GitHub webhooks
router.post('/github', webhookController.handleGitHubWebhook);

// Endpoint for receiving Postman webhooks
router.post('/postman', webhookController.handlePostmanWebhook);

export default router;
