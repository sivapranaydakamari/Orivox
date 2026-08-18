import { Router } from 'express';
import { githubAppController } from '../controller/github-app.controller';
import { requireAuth, requireOrganization, requireOrgRole } from '../../../middleware/auth.middleware';
import { OrgRole } from '../../user/model/user.model';

const router = Router();

// Callback from GitHub after installation (public route)
router.get('/callback', githubAppController.handleCallback.bind(githubAppController));

// These routes require the user to be logged in and inside an organization context
router.use(requireAuth);
router.use(requireOrganization);

// Only ORG_ADMIN can initiate an installation
router.get(
  '/install',
  requireOrgRole([OrgRole.ORG_ADMIN]),
  githubAppController.getInstallUrl.bind(githubAppController)
);

// List installations for the current organization
router.get(
  '/installations',
  requireOrgRole([OrgRole.ORG_ADMIN, OrgRole.MANAGER, OrgRole.TEAM_LEAD, OrgRole.EMPLOYEE]),
  githubAppController.listInstallations.bind(githubAppController)
);

// List repositories for a specific installation
router.get(
  '/installations/:installationId/repositories',
  requireOrgRole([OrgRole.ORG_ADMIN, OrgRole.MANAGER, OrgRole.TEAM_LEAD, OrgRole.EMPLOYEE]),
  githubAppController.listRepositories.bind(githubAppController)
);

export default router;
