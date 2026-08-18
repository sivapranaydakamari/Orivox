import app from './app';
import { logger } from './config/logger';
import { startServer } from './config/server';

process.on('unhandledRejection', (reason: unknown) => {
  logger.error({ err: reason }, 'Unhandled Promise Rejection');
  process.exit(1);
});

process.on('uncaughtException', (error: Error) => {
  logger.error({ err: error }, 'Uncaught Exception');
  process.exit(1);
});

startServer(app);
