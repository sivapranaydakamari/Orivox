import { Router } from 'express';
import { syncController } from '../controller/sync.controller';
import { validate } from '../../../middleware/validate.middleware';
import { syncRepositorySchema } from '../validation/sync.validation';

import { requireProjectAccess, requireRole } from '../../../middleware/auth.middleware';
import { ProjectRole } from '../../user/model/user.model';
import { repositoryService } from '../../repository/service/repository.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';

const router = Router({ mergeParams: true });

router.param('id', async (req, res, next, id) => {
  try {
    const repo = await repositoryService.getRepositoryById(id);
    if (!repo) return ApiResponse.error(res, 'Repository not found', null, 404);
    req.params.projectId = repo.projectId.toString();
    next();
  } catch (err) {
    next(err);
  }
});

router.post('/:id/sync', validate(syncRepositorySchema), requireRole([ProjectRole.PROJECT_ADMIN, ProjectRole.PROJECT_MANAGER, ProjectRole.TEAM_LEAD]), syncController.sync);
router.get('/:id/sync-status', validate(syncRepositorySchema), requireProjectAccess, syncController.getStatus);
router.get('/:id/sync-history', validate(syncRepositorySchema), requireProjectAccess, syncController.getHistory);

export default router;
