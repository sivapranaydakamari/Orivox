import { Router } from 'express';
import { jobController } from '../controller/job.controller';
import { requireAuth } from '../../../middleware/auth.middleware';

const router = Router();

router.use(requireAuth);
router.get('/metrics', jobController.getMetrics);
router.get('/:id', jobController.getStatus);
router.post('/:id/retry', jobController.retryJob);

export default router;
