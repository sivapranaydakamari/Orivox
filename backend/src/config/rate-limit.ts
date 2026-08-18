import rateLimit from 'express-rate-limit';
import { ApiResponse } from '../shared/utils/apiResponse';
import { Request, Response } from 'express';

export const globalLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100, // Limit each IP to 100 requests per `window` (here, per minute)
  standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
  legacyHeaders: false, // Disable the `X-RateLimit-*` headers
  handler: (req: Request, res: Response) => {
    return ApiResponse.error(res, 'Too many requests, please try again later.', null, 429);
  },
});

export const authLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 5, // Limit each IP to 5 requests per minute
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req: Request, res: Response) => {
    return ApiResponse.error(res, 'Too many login attempts, please try again after a minute.', null, 429);
  },
});

export const askLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 10, // Limit each IP to 10 requests per minute
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req: Request, res: Response) => {
    return ApiResponse.error(res, 'Too many AI requests, please try again after a minute.', null, 429);
  },
});
