import { Request, Response } from 'express';
import { repositoryService } from '../service/repository.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';
import { auditService } from '../../audit/service/audit.service';
import { userRepository } from '../../user/repository/user.repository';
import { OrgRole } from '../../user/model/user.model';
import { env } from '../../../config/env';
import { logger } from '../../../config/logger';

import { queueService } from '../../jobs/queue.service';
import { JobType } from '../../jobs/types/job.types';

export class RepositoryController {
  create = asyncHandler(async (req: Request, res: Response) => {
    // Override initial status to PENDING
    const payload = { ...req.body, syncStatus: 'PENDING' };
    const repository = await repositoryService.createRepository(payload);
    
    await auditService.logAction(req.user!.organizationId, 'REPOSITORY_ADDED', 'REPOSITORY', repository._id.toString(), req.user!.id, repository.projectId.toString());
    
    // Enqueue initial sync
    try {
      await queueService.enqueue(
        JobType.SYNC_REPOSITORY, 
        { repositoryId: repository._id.toString() }
      );
    } catch (err: any) {
      logger.error({ err, repositoryId: repository._id.toString() }, 'Failed to enqueue initial sync job');
      // We don't fail the creation, but it remains PENDING.
    }
    
    ApiResponse.success(res, repository, 'Repository connected and sync queued', 202);
  });

  getAll = asyncHandler(async (req: Request, res: Response) => {
    const user = await userRepository.findById(req.user!.id);
    if (!user) return ApiResponse.error(res, 'User not found', null, 401);
    
    const orgMembership = user.memberships.find(m => m.organizationId.toString() === req.user!.organizationId);
    if (!orgMembership) return ApiResponse.error(res, 'Access denied', null, 403);

    const repositories = await repositoryService.getRepositories(req.user!.organizationId);
    
    // Filter repositories based on project access
    let filteredRepositories = repositories;
    if (orgMembership.orgRole !== OrgRole.ORG_ADMIN) {
      const allowedProjectIds = orgMembership.projectRoles.map(p => p.projectId.toString());
      filteredRepositories = repositories.filter(repo => allowedProjectIds.includes(repo.projectId.toString()));
    }

    ApiResponse.success(res, filteredRepositories, 'Repositories retrieved successfully');
  });

  getById = asyncHandler(async (req: Request, res: Response) => {
    const repository = await repositoryService.getRepositoryById(req.params.id as string);
    if (!repository) {
      return ApiResponse.error(res, 'Repository not found', null, 404);
    }
    ApiResponse.success(res, repository, 'Repository retrieved successfully');
  });

  update = asyncHandler(async (req: Request, res: Response) => {
    const repository = await repositoryService.updateRepository(req.params.id as string, req.body);
    if (!repository) {
      return ApiResponse.error(res, 'Repository not found', null, 404);
    }
    ApiResponse.success(res, repository, 'Repository updated successfully');
  });

  delete = asyncHandler(async (req: Request, res: Response) => {
    const success = await repositoryService.deleteRepository(req.params.id as string);
    if (!success) {
      return ApiResponse.error(res, 'Repository not found', null, 404);
    }
    ApiResponse.success(res, null, 'Repository deleted successfully');
  });

  generateWebhookSecret = asyncHandler(async (req: Request, res: Response) => {

    const crypto = await import('crypto');
    const secret = crypto.randomBytes(32).toString('hex');
    
    // Update repository
    const repository = await repositoryService.updateRepository(req.params.id as string, {
      webhookSecret: secret,
      webhookStatus: 'PENDING',
    } as any);

    if (!repository) {
      return ApiResponse.error(res, 'Repository not found', null, 404);
    }

    const baseUrl = env.NODE_ENV === 'development' 
      ? `http://localhost:${env.PORT}` 
      : (process.env.RENDER_EXTERNAL_URL || 'https://orivox-backend.onrender.com');
    const webhookUrl = `${baseUrl}/api/v1/integrations/github/webhook`;

    // Return the secret ONCE.
    ApiResponse.success(res, { secret, webhookUrl }, 'Webhook secret generated successfully');
  });
}

export const repositoryController = new RepositoryController();
