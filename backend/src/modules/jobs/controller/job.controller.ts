import { Request, Response } from 'express';
import { queueService } from '../queue.service';
import { workerMetricRepository } from '../repository/workerMetric.repository';
import { JobType } from '../types/job.types';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';

export class JobController {
  getStatus = asyncHandler(async (req: Request, res: Response) => {
    const jobId = req.params.id as string;
    const status = await queueService.getJobStatus(jobId);
    
    if (status.status === 'unknown') {
      return ApiResponse.error(res, 'Job not found', null, 404);
    }

    ApiResponse.success(res, status, 'Job status retrieved successfully');
  });

  getMetrics = asyncHandler(async (req: Request, res: Response) => {
    const metrics = await workerMetricRepository.findAll();
    ApiResponse.success(res, metrics, 'Job metrics retrieved successfully');
  });

  getFailedJobs = asyncHandler(async (req: Request, res: Response) => {
    const jobType = req.query.type as JobType;
    if (!jobType || !Object.values(JobType).includes(jobType)) {
      return ApiResponse.error(res, 'Valid job type query parameter is required', null, 400);
    }
    const limit = req.query.limit ? parseInt(req.query.limit as string) : 50;
    const failedJobs = await queueService.getFailedJobs(jobType, limit);
    ApiResponse.success(res, failedJobs, 'Failed jobs retrieved successfully');
  });

  retryJob = asyncHandler(async (req: Request, res: Response) => {
    const jobId = req.params.id as string;
    if (!jobId) {
      return ApiResponse.error(res, 'Job ID is required', null, 400);
    }
    const success = await queueService.retryJob(jobId);
    if (!success) {
      return ApiResponse.error(res, 'Failed job not found or could not be retried', null, 404);
    }
    ApiResponse.success(res, null, 'Job queued for retry');
  });
}

export const jobController = new JobController();
