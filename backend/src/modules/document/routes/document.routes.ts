import { Router } from 'express';
import { documentController } from '../controller/document.controller';
import { validate } from '../../../middleware/validate.middleware';
import { getDocumentSchema, getDocumentsQuerySchema } from '../validation/document.validation';

import { requireProjectAccess, requireRole } from '../../../middleware/auth.middleware';
import { ProjectRole } from '../../user/model/user.model';
import { documentService } from '../service/document.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';

const router = Router();

// Middleware to resolve projectId for document endpoints
router.param('id', async (req, res, next, id) => {
  try {
    const doc = await documentService.getDocumentById(id);
    if (!doc) {
      return ApiResponse.error(res, 'Document not found', null, 404);
    }
    req.params.projectId = doc.projectId.toString();
    next();
  } catch (error) {
    next(error);
  }
});

router.get('/', validate(getDocumentsQuerySchema), documentController.getAll); // Requires controller filtering
router.post('/', requireRole([ProjectRole.PROJECT_ADMIN, ProjectRole.PROJECT_MANAGER, ProjectRole.TEAM_LEAD, ProjectRole.ENGINEER]), documentController.create);
router.post('/postman', requireRole([ProjectRole.PROJECT_ADMIN, ProjectRole.PROJECT_MANAGER, ProjectRole.TEAM_LEAD, ProjectRole.ENGINEER]), documentController.ingestPostman);
router.get('/:id', validate(getDocumentSchema), requireProjectAccess, documentController.getById);

export default router;
