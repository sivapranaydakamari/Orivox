import { Router } from 'express';
import { repositoryController } from '../controller/repository.controller';
import { validate } from '../../../middleware/validate.middleware';
import {
  createRepositorySchema,
  updateRepositorySchema,
  getRepositorySchema,
} from '../validation/repository.validation';

import { requireProjectAccess, requireRole } from '../../../middleware/auth.middleware';
import { ProjectRole } from '../../user/model/user.model';
import { repositoryService } from '../service/repository.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';

const router = Router();

// Middleware to resolve projectId for repository endpoints
router.param('id', async (req, res, next, id) => {
  try {
    const repo = await repositoryService.getRepositoryById(id);
    if (!repo) {
      return ApiResponse.error(res, 'Repository not found', null, 404);
    }
    req.params.projectId = repo.projectId.toString();
    next();
  } catch (error) {
    next(error);
  }
});

router.post('/', validate(createRepositorySchema), requireRole([ProjectRole.PROJECT_ADMIN, ProjectRole.PROJECT_MANAGER]), repositoryController.create);
router.get('/', repositoryController.getAll); 
router.get('/:id', validate(getRepositorySchema), requireProjectAccess, repositoryController.getById);
router.patch('/:id', validate(updateRepositorySchema), requireRole([ProjectRole.PROJECT_ADMIN, ProjectRole.PROJECT_MANAGER]), repositoryController.update);
router.delete('/:id', validate(getRepositorySchema), requireRole([ProjectRole.PROJECT_ADMIN, ProjectRole.PROJECT_MANAGER]), repositoryController.delete);
router.post('/:id/webhook-secret', validate(getRepositorySchema), requireRole([ProjectRole.PROJECT_ADMIN, ProjectRole.PROJECT_MANAGER]), repositoryController.generateWebhookSecret);

export default router;
