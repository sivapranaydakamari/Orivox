import pino from 'pino';
import pinoHttp from 'pino-http';
import { env } from './env';
import { Request, Response } from 'express';

export const logger = pino({
  level: env.NODE_ENV === 'development' ? 'debug' : 'info',
  mixin() {
    // eslint-disable-next-line @typescript-eslint/no-require-imports
    const { getRequestId } = require('../shared/context/request.context');
    const requestId = getRequestId();
    return requestId ? { requestId } : {};
  },
  transport:
    env.NODE_ENV === 'development'
      ? {
          target: 'pino-pretty',
          options: { colorize: true },
        }
      : undefined,
});

export const requestLogger = pinoHttp({
  logger,
  customProps: (req: Request, _res: Response) => ({
    requestId: req.headers['x-request-id'] || req.id,
  }),
  // Optional: customize log levels or serialization here
});
