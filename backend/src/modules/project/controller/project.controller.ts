import { Request, Response } from 'express';
import { projectService } from '../service/project.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';
import { auditService } from '../../audit/service/audit.service';

export class ProjectController {
  create = asyncHandler(async (req: Request, res: Response) => {
    const projectData = { ...req.body, organizationId: req.user!.organizationId };
    const project = await projectService.createProject(projectData);
    
    await auditService.logAction(req.user!.organizationId, 'PROJECT_CREATED', 'PROJECT', project._id.toString(), req.user!.id);
    
    ApiResponse.success(res, project, 'Project created successfully', 201);
  });

  getAll = asyncHandler(async (req: Request, res: Response) => {
    const { userRepository } = await import('../../user/repository/user.repository');
    const { OrgRole } = await import('../../user/model/user.model');
    const user = await userRepository.findById(req.user!.id);
    if (!user) return ApiResponse.error(res, 'User not found', null, 401);
    
    const orgMembership = user.memberships.find(m => m.organizationId.toString() === req.user!.organizationId);
    if (!orgMembership) return ApiResponse.error(res, 'Access denied', null, 403);

    const projects = await projectService.getProjects(req.user!.organizationId);
    
    // Filter projects based on access
    let filteredProjects = projects;
    if (orgMembership.orgRole !== OrgRole.ORG_ADMIN) {
      const allowedProjectIds = orgMembership.projectRoles.map(p => p.projectId.toString());
      filteredProjects = projects.filter(project => allowedProjectIds.includes(project._id.toString()));
    }

    ApiResponse.success(res, filteredProjects, 'Projects retrieved successfully');
  });

  getById = asyncHandler(async (req: Request, res: Response) => {
    const project = await projectService.getProjectById(req.params.id as string);
    if (!project) {
      return ApiResponse.error(res, 'Project not found', null, 404);
    }
    ApiResponse.success(res, project, 'Project retrieved successfully');
  });

  update = asyncHandler(async (req: Request, res: Response) => {
    const project = await projectService.updateProject(req.params.id as string, req.body);
    if (!project) {
      return ApiResponse.error(res, 'Project not found', null, 404);
    }
    ApiResponse.success(res, project, 'Project updated successfully');
  });

  delete = asyncHandler(async (req: Request, res: Response) => {
    const success = await projectService.deleteProject(req.params.id as string);
    if (!success) {
      return ApiResponse.error(res, 'Project not found', null, 404);
    }
    ApiResponse.success(res, null, 'Project deleted successfully');
  });
}

export const projectController = new ProjectController();
