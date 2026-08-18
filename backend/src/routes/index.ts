import { Router } from 'express';
import healthRoutes from '../modules/health/routes/health.routes';
import authRoutes from '../modules/auth/routes/auth.routes';
import organizationRoutes from '../modules/organization/routes/organization.routes';
import projectRoutes from '../modules/project/routes/project.routes';
import repositoryRoutes from '../modules/repository/routes/repository.routes';
import documentRoutes from '../modules/document/routes/document.routes';
import knowledgeRoutes from '../modules/knowledge/routes/knowledge.routes';
import syncRoutes from '../modules/integration/routes/sync.routes';
import intelligenceRoutes from '../modules/intelligence/routes/intelligence.routes';
import jobRoutes from '../modules/jobs/routes/job.routes';
import { requireAuth, requireOrganization } from '../middleware/auth.middleware';
import userRoutes from '../modules/user/routes/user.routes';
import webhookRoutes from '../modules/integration/routes/webhook.routes';

const router = Router();

// Public routes
router.use('/health', healthRoutes);
router.use('/auth', authRoutes);
router.use('/integrations', webhookRoutes);

// Protected routes (Require Authentication)
const apiRouter = Router();
apiRouter.use(requireAuth);

apiRouter.use('/user', userRoutes);

// Organization Routes (Organizations manage their own context, so we might just require Auth)
apiRouter.use('/organizations', organizationRoutes);

// Protected routes (Require both Authentication and Organization Context)
apiRouter.use(requireOrganization);

apiRouter.use('/projects', projectRoutes);
apiRouter.use('/repositories', repositoryRoutes);
apiRouter.use('/documents', documentRoutes);
apiRouter.use('/knowledge', knowledgeRoutes);

// Sync endpoints are nested under repositories
apiRouter.use('/repositories', syncRoutes);

// Intelligence (Ask AI)
apiRouter.use('/', intelligenceRoutes); // This contains /ask

// Jobs API
apiRouter.use('/jobs', jobRoutes);

// Mount API router
router.use('/', apiRouter);

export default router;
