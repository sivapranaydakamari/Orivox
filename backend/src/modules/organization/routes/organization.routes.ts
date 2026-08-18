import { Router } from 'express';
import { organizationController } from '../controller/organization.controller';
import { validate } from '../../../middleware/validate.middleware';
import {
  createOrganizationSchema,
  updateOrganizationSchema,
  getOrganizationSchema,
} from '../validation/organization.validation';

const router = Router();

router.post('/', validate(createOrganizationSchema), organizationController.create);
router.get('/', organizationController.getAll);
router.get('/:id', validate(getOrganizationSchema), organizationController.getById);
router.patch('/:id', validate(updateOrganizationSchema), organizationController.update);
router.delete('/:id', validate(getOrganizationSchema), organizationController.delete);

// Membership Routes
import { memberController } from '../controller/member.controller';
import { requireOrgRole } from '../../../middleware/auth.middleware';
import { OrgRole } from '../../user/model/user.model';

router.get('/:id/members', validate(getOrganizationSchema), requireOrgRole([OrgRole.ORG_ADMIN]), memberController.getOrganizationMembers);
router.post('/:id/members', validate(getOrganizationSchema), requireOrgRole([OrgRole.ORG_ADMIN]), memberController.addOrganizationMember);
router.patch('/:id/members/:userId/role', validate(getOrganizationSchema), requireOrgRole([OrgRole.ORG_ADMIN]), memberController.updateOrganizationRole);
router.delete('/:id/members/:userId', validate(getOrganizationSchema), requireOrgRole([OrgRole.ORG_ADMIN]), memberController.removeOrganizationMember);

export default router;
