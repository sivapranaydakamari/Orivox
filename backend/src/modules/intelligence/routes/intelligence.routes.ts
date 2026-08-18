import { Router } from 'express';
import { intelligenceController } from '../controller/intelligence.controller';
import { validate } from '../../../middleware/validate.middleware';
import { askSchema } from '../validation/ask.validation';

import { askLimiter } from '../../../config/rate-limit';

import { requireProjectAccess } from '../../../middleware/auth.middleware';

const router = Router();

router.post('/ask', askLimiter, validate(askSchema), requireProjectAccess, intelligenceController.ask);

export default router;
