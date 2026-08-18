import { Request, Response } from 'express';
import { repositoryService } from '../../repository/service/repository.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';
import { auditService } from '../../audit/service/audit.service';
import { queueService } from '../../jobs/queue.service';
import { JobType } from '../../jobs/types/job.types';

export class SyncController {
  sync = asyncHandler(async (req: Request, res: Response) => {
    const repositoryId = req.params.id as string;
    const repository = await repositoryService.getRepositoryById(repositoryId);
    
    if (!repository) {
      return ApiResponse.error(res, 'Repository not found', null, 404);
    }

    try {
      const projectIdStr = repository.projectId ? repository.projectId.toString() : undefined;
      await auditService.logAction(req.user!.organizationId, 'SYNC_STARTED', 'REPOSITORY', repositoryId, req.user!.id, projectIdStr);
    } catch (_auditErr) {
      // Audit log error should not block request execution
    }

    // Safely retrieve providerToken from request body if present
    const providerToken = (req.body && req.body.providerToken) ? req.body.providerToken : '';

    // Enqueue the sync job
    try {
      const jobId = await queueService.enqueue(
        JobType.SYNC_REPOSITORY, 
        { repositoryId, providerToken }
      );
      return ApiResponse.success(res, { syncStatus: 'QUEUED', jobId }, 'Synchronization triggered successfully', 202);
    } catch (err: any) {
      return ApiResponse.error(res, `Failed to enqueue sync job: ${err.message || 'Queue connection error'}`, null, 500);
    }
  });

  getStatus = asyncHandler(async (req: Request, res: Response) => {
    const repositoryId = req.params.id as string;
    const repository = await repositoryService.getRepositoryById(repositoryId);
    
    if (!repository) {
      return ApiResponse.error(res, 'Repository not found', null, 404);
    }

    const statusResponse = {
      syncStatus: repository.syncStatus,
      lastSuccessfulSync: repository.lastSuccessfulSync,
      lastProcessedPullRequest: repository.lastProcessedPullRequest,
      syncError: repository.syncError,
    };

    ApiResponse.success(res, statusResponse, 'Sync status retrieved successfully');
  });

  getHistory = asyncHandler(async (req: Request, res: Response) => {
    // History not fully modeled yet; return empty for now
    ApiResponse.success(res, [], 'Sync history retrieved successfully (Feature pending implementation)');
  });
}

export const syncController = new SyncController();
