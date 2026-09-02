import { Router } from 'express';
import { githubAppController } from '../controller/github-app.controller';
import { requireAuth, requireOrganization, requireOrgRole } from '../../../middleware/auth.middleware';
import { OrgRole } from '../../user/model/user.model';
import { User } from '../../user/model/user.model';

const router = Router();

// Callback from GitHub after installation (public route)
router.get('/callback', githubAppController.handleCallback.bind(githubAppController));

// Temporary debug endpoint to diagnose Render environment variable mangling
router.get('/debug-key', (req, res) => {
  const pk = process.env.GITHUB_APP_PRIVATE_KEY || '';
  // Safely print the length and the character codes of the start/end to avoid exposing the actual key
  const startChars = pk.substring(0, 35).split('').map(c => c === '\n' ? '\\n' : c === '\r' ? '\\r' : c).join('');
  const endChars = pk.substring(pk.length - 35).split('').map(c => c === '\n' ? '\\n' : c === '\r' ? '\\r' : c).join('');
  res.json({
    length: pk.length,
    start: startChars,
    end: endChars,
    includesNewline: pk.includes('\n'),
    includesEscapedNewline: pk.includes('\\n'),
    includesQuote: pk.includes('"') || pk.includes("'"),
    exactChars: pk.split('').map(c => c.charCodeAt(0)), // Return all char codes for absolute certainty
  });
});

// Temporary debug endpoint to fix user permissions
router.get('/make-admin', async (req, res) => {
  const email = req.query.email;
  if (!email) return res.status(400).json({ error: 'Missing email query param' });
  
  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ error: 'User not found' });
    
    // Update all memberships to ORG_ADMIN
    user.memberships.forEach(m => {
      m.orgRole = OrgRole.ORG_ADMIN;
    });
    
    await user.save();
    
    res.json({ message: `Successfully made ${email} an ORG_ADMIN in all their orgs`, user });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

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
// List all repositories for all installations
router.get(
  '/repositories',
  requireOrgRole([OrgRole.ORG_ADMIN, OrgRole.MANAGER, OrgRole.TEAM_LEAD, OrgRole.EMPLOYEE]),
  githubAppController.listAllRepositories.bind(githubAppController)
);

// Reconcile an existing installation manually
router.post(
  '/installations/reconcile',
  requireOrgRole([OrgRole.ORG_ADMIN]),
  githubAppController.reconcileInstallation.bind(githubAppController)
);

export default router;
