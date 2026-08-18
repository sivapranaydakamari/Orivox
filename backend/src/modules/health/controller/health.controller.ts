import { Request, Response } from 'express';
import mongoose from 'mongoose';
import { AppConstants } from '../../../shared/constants/app.constants';
import { env } from '../../../config/env';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';

export const checkHealth = asyncHandler(async (req: Request, res: Response) => {
  const isDbConnected = mongoose.connection.readyState === 1;

  const data = {
    status: 'UP',
    service: AppConstants.SERVICE_NAME,
    version: AppConstants.VERSION,
    environment: env.NODE_ENV,
    database: isDbConnected ? 'connected' : 'disconnected',
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
  };

  ApiResponse.success(res, data, 'Service is healthy');
});
