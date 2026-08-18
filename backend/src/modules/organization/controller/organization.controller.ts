import { Request, Response } from 'express';
import { organizationService } from '../service/organization.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';

import { userRepository } from '../../user/repository/user.repository';

export class OrganizationController {
  create = asyncHandler(async (req: Request, res: Response) => {
    const organization = await organizationService.createOrganization(req.user!.id, req.body);
    ApiResponse.success(res, organization, 'Organization created successfully', 201);
  });

  getAll = asyncHandler(async (req: Request, res: Response) => {
    const user = await userRepository.findById(req.user!.id);
    if (!user) {
      return ApiResponse.success(res, [], 'Organizations retrieved successfully');
    }
    const orgIds = user.memberships.map(m => m.organizationId.toString());
    const organizations = await organizationService.getOrganizations(orgIds);
    ApiResponse.success(res, organizations, 'Organizations retrieved successfully');
  });

  getById = asyncHandler(async (req: Request, res: Response) => {
    const organization = await organizationService.getOrganizationById(req.params.id as string);
    if (!organization) {
      return ApiResponse.error(res, 'Organization not found', null, 404);
    }
    ApiResponse.success(res, organization, 'Organization retrieved successfully');
  });

  update = asyncHandler(async (req: Request, res: Response) => {
    const organization = await organizationService.updateOrganization(req.params.id as string, req.body);
    if (!organization) {
      return ApiResponse.error(res, 'Organization not found', null, 404);
    }
    ApiResponse.success(res, organization, 'Organization updated successfully');
  });

  delete = asyncHandler(async (req: Request, res: Response) => {
    const success = await organizationService.deleteOrganization(req.params.id as string);
    if (!success) {
      return ApiResponse.error(res, 'Organization not found', null, 404);
    }
    ApiResponse.success(res, null, 'Organization deleted successfully');
  });
}

export const organizationController = new OrganizationController();
