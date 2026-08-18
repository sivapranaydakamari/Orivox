import { Router } from 'express';
import { authController } from '../controller/auth.controller';
import { validate } from '../../../middleware/validate.middleware';
import { loginSchema, registerSchema, resetPasswordSchema, refreshSchema, logoutSchema } from '../validation/auth.validation';

import { authLimiter } from '../../../config/rate-limit';

const router = Router();

router.post('/login', authLimiter, validate(loginSchema), authController.login);
router.post('/register', validate(registerSchema), authController.register);
router.post('/refresh', validate(refreshSchema), authController.refresh);
router.post('/logout', validate(logoutSchema), authController.logout);
router.post('/reset-password', validate(resetPasswordSchema), authController.resetPassword);

// Protected Auth Routes
import { requireAuth } from '../../../middleware/auth.middleware';
router.get('/sessions', requireAuth, authController.getSessions);
router.post('/sessions/logout-all', requireAuth, authController.logoutAll);

export default router;
