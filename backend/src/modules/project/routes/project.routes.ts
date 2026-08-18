import { Router } from 'express';
import { projectController } from '../controller/project.controller';
import { validate } from '../../../middleware/validate.middleware';
import { requireProjectAccess, requireRole, requireOrgRole } from '../../../middleware/auth.middleware';
import { ProjectRole, OrgRole } from '../../user/model/user.model';
import {
  createProjectSchema,
  updateProjectSchema,
  getProjectSchema,
} from '../validation/project.validation';

const router = Router();

// Map :id to :projectId for auth middleware compatibility
router.param('id', (req, res, next, id) => {
  req.params.projectId = id;
  next();
});

router.post('/', validate(createProjectSchema), requireOrgRole([OrgRole.ORG_ADMIN, OrgRole.MANAGER]), projectController.create);
router.get('/', projectController.getAll); 
router.get('/:id', validate(getProjectSchema), requireProjectAccess, projectController.getById);
router.patch('/:id', validate(updateProjectSchema), requireRole([ProjectRole.PROJECT_ADMIN, ProjectRole.PROJECT_MANAGER]), projectController.update);
router.delete('/:id', validate(getProjectSchema), requireRole([ProjectRole.PROJECT_ADMIN]), projectController.delete);

// Membership Routes
import { memberController } from '../../organization/controller/member.controller';

router.get('/:id/members', validate(getProjectSchema), requireRole([ProjectRole.PROJECT_ADMIN, ProjectRole.PROJECT_MANAGER]), memberController.getProjectMembers);
router.post('/:id/members', validate(getProjectSchema), requireRole([ProjectRole.PROJECT_ADMIN]), memberController.addProjectMember);
router.patch('/:id/members/:userId/role', validate(getProjectSchema), requireRole([ProjectRole.PROJECT_ADMIN]), memberController.updateProjectRole);
router.delete('/:id/members/:userId', validate(getProjectSchema), requireRole([ProjectRole.PROJECT_ADMIN]), memberController.removeProjectMember);

export default router;
