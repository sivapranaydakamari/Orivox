import { Router } from 'express';
import { checkHealth } from '../controller/health.controller';

const router = Router();

router.get('/', checkHealth);

export default router;
