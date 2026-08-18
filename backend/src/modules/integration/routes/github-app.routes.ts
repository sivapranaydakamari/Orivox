import { Router } from 'express';
import { githubAppController } from '../controller/github-app.controller';
import { requireAuth, requireOrganization } from '../../../middleware/auth.middleware';
import { requireRole } from '../../../middleware/role.middleware';
import { SystemRole } from '../../user/model/user.model';

const router = Router();

// Callback from GitHub after installation (public route)
router.get('/callback', githubAppController.handleCallback.bind(githubAppController));

// These routes require the user to be logged in and inside an organization context
router.use(requireAuth);
router.use(requireOrganization);

// Only ORG_ADMIN can initiate an installation
router.get(
  '/install',
  requireRole([SystemRole.ORG_ADMIN]),
  githubAppController.getInstallUrl.bind(githubAppController)
);

// List installations for the current organization
router.get(
  '/installations',
  requireRole([SystemRole.ORG_ADMIN, SystemRole.MANAGER, SystemRole.TEAM_LEAD, SystemRole.EMPLOYEE]),
  githubAppController.listInstallations.bind(githubAppController)
);

// List repositories for a specific installation
router.get(
  '/installations/:installationId/repositories',
  requireRole([SystemRole.ORG_ADMIN, SystemRole.MANAGER, SystemRole.TEAM_LEAD, SystemRole.EMPLOYEE]),
  githubAppController.listRepositories.bind(githubAppController)
);

export default router;
