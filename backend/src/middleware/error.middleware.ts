import { Request, Response, NextFunction } from 'express';
import { logger } from '../config/logger';
import { ZodError } from 'zod';
import { ApiResponse } from '../shared/utils/apiResponse';
import { HttpStatus } from '../shared/constants/http.constants';

export const globalErrorHandler = (
   
  err: any,
  req: Request,
  res: Response,
  _next: NextFunction
): void => {
  logger.error({ err }, 'Global Error Handler caught an error');

  if (err instanceof ZodError) {
    ApiResponse.error(res, 'Validation Error', err.issues, HttpStatus.BAD_REQUEST);
    return;
  }

  const statusCode = err?.status || HttpStatus.INTERNAL_SERVER_ERROR;
  const message = err?.message || 'Internal Server Error';

  ApiResponse.error(res, message, null, statusCode);
};
