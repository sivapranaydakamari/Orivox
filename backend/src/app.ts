import express from 'express';
import { requestLogger } from './config/logger';
import { configureSecurity } from './config/security';
import routes from './routes';
import { globalErrorHandler } from './middleware/error.middleware';
import { notFoundHandler } from './middleware/notFound.middleware';
import { requestIdMiddleware } from './middleware/requestId.middleware';

const app = express();

import { globalLimiter } from './config/rate-limit';

// Security middleware
configureSecurity(app);

// Global rate limiting
app.use(globalLimiter);

// Request ID middleware
app.use(requestIdMiddleware);

// Body parser
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging (pino-http)
app.use(requestLogger);

// API Routes
app.use('/api/v1', routes);

// 404 Handler
app.use(notFoundHandler);


import { sourceRegistry } from './modules/integration/registry/source.registry';
import { GitHubProvider } from './modules/integration/providers/github.provider';
import { GitHubClient } from './modules/integration/clients/github.client';
import { DocumentSourceType } from './modules/document/model/document.model';

// Register Source Providers
sourceRegistry.registerProvider(
  DocumentSourceType.GITHUB,
  new GitHubProvider(new GitHubClient())
);



// Global Error Handler
app.use(globalErrorHandler);

export default app;
