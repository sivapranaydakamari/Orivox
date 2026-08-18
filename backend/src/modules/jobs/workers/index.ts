import './embedding.worker';
import './extraction.worker';
import './retry.worker';
import './sync.worker';
import './webhook.worker';
import './postman.worker';

import { logger } from '../../../config/logger';

export const initializeWorkers = () => {
  logger.info('Background workers registered with BullMQ');
};
