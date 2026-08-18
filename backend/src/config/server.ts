import { Application } from 'express';
import { env } from './env';
import { logger } from './logger';
import { connectDatabase } from './database';

import { outboxProcessor } from '../modules/jobs/workers/outbox.processor';
import { initializeWorkers } from '../modules/jobs/workers';

export const startServer = async (app: Application) => {
  await connectDatabase();

  // Start background workers and processors AFTER db connection
  initializeWorkers();
  outboxProcessor.start();

  app.listen(env.PORT, () => {
    logger.info(`Server is running on port ${env.PORT} in ${env.NODE_ENV} mode`);
  });
};
