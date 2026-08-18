import { Router } from 'express';
import { userController } from '../controller/user.controller';

const router = Router();

router.get('/profile', userController.getProfile);
router.put('/profile', userController.updateProfile);
router.post('/change-password', userController.changePassword);

export default router;
