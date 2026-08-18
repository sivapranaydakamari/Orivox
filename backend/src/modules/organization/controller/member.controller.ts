import { Request, Response } from 'express';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';
import { auditService } from '../../audit/service/audit.service';
import { userRepository } from '../../user/repository/user.repository';
import { userService } from '../../user/service/user.service';
import { OrgRole, ProjectRole } from '../../user/model/user.model';
import { Types } from 'mongoose';

export class MemberController {
  
  // ================= ORGANIZATION MEMBERSHIP =================

  getOrganizationMembers = asyncHandler(async (req: Request, res: Response) => {
    const orgId = req.params.id as string;
    // Find all users who have a membership in this organization
    const users = await userRepository.findMany({ 'memberships.organizationId': new Types.ObjectId(orgId) });
    
    // Format response to only include relevant membership data
    const members = users.map(user => {
      const membership = user.memberships.find(m => m.organizationId.toString() === orgId);
      return {
        id: user._id,
        name: user.name,
        email: user.email,
        orgRole: membership?.orgRole,
        projectRoles: membership?.projectRoles || [],
      };
    });

    ApiResponse.success(res, members, 'Organization members retrieved');
  });

  addOrganizationMember = asyncHandler(async (req: Request, res: Response) => {
    const orgId = req.params.id as string;
    const { email, role } = req.body;

    if (!email) {
      return ApiResponse.error(res, 'Email is required', null, 400);
    }
    
    const orgRole = role || OrgRole.EMPLOYEE;
    if (!Object.values(OrgRole).includes(orgRole)) {
      return ApiResponse.error(res, 'Invalid organization role', null, 400);
    }

    const targetUser = await userService.getByEmail(email);
    if (!targetUser) {
      return ApiResponse.error(res, 'User with this email not found', null, 404);
    }

    // Check if already a member
    const existingMembership = targetUser.memberships.find(m => m.organizationId.toString() === orgId);
    if (existingMembership) {
      return ApiResponse.error(res, 'User is already a member of this organization', null, 400);
    }

    targetUser.memberships.push({
      organizationId: new Types.ObjectId(orgId),
      orgRole: orgRole,
      projectRoles: []
    });

    await userRepository.update(targetUser._id!.toString(), { memberships: targetUser.memberships });
    await auditService.logAction(orgId, 'ORG_MEMBER_ADDED', 'USER', targetUser._id!.toString(), req.user!.id);

    ApiResponse.success(res, { id: targetUser._id, name: targetUser.name, orgRole }, 'Member added successfully');
  });

  updateOrganizationRole = asyncHandler(async (req: Request, res: Response) => {
    const orgId = req.params.id as string;
    const userId = req.params.userId as string;
    const { role } = req.body;

    if (!Object.values(OrgRole).includes(role)) {
      return ApiResponse.error(res, 'Invalid organization role', null, 400);
    }

    const targetUser = await userRepository.findById(userId);
    if (!targetUser) {
      return ApiResponse.error(res, 'User not found', null, 404);
    }

    const membership = targetUser.memberships.find(m => m.organizationId.toString() === orgId);
    if (!membership) {
      return ApiResponse.error(res, 'User is not a member of this organization', null, 400);
    }

    membership.orgRole = role;
    await userRepository.update(userId, { memberships: targetUser.memberships });
    await auditService.logAction(orgId, 'ORG_MEMBER_ROLE_UPDATED', 'USER', userId, req.user!.id);

    ApiResponse.success(res, null, 'Organization role updated successfully');
  });

  removeOrganizationMember = asyncHandler(async (req: Request, res: Response) => {
    const orgId = req.params.id as string;
    const userId = req.params.userId as string;

    const targetUser = await userRepository.findById(userId);
    if (!targetUser) {
      return ApiResponse.error(res, 'User not found', null, 404);
    }

    const membershipIndex = targetUser.memberships.findIndex(m => m.organizationId.toString() === orgId);
    if (membershipIndex === -1) {
      return ApiResponse.error(res, 'User is not a member of this organization', null, 400);
    }

    // Protect against removing the last ORG_ADMIN
    if (targetUser.memberships[membershipIndex].orgRole === OrgRole.ORG_ADMIN) {
      const allAdmins = await userRepository.findMany({ 
        'memberships': { 
          $elemMatch: { organizationId: new Types.ObjectId(orgId), orgRole: OrgRole.ORG_ADMIN } 
        } 
      });
      if (allAdmins.length <= 1) {
        return ApiResponse.error(res, 'Cannot remove the last organization administrator', null, 400);
      }
    }

    targetUser.memberships.splice(membershipIndex, 1);
    await userRepository.update(userId, { memberships: targetUser.memberships });
    await auditService.logAction(orgId, 'ORG_MEMBER_REMOVED', 'USER', userId, req.user!.id);

    ApiResponse.success(res, null, 'Member removed successfully');
  });


  // ================= PROJECT MEMBERSHIP =================

  getProjectMembers = asyncHandler(async (req: Request, res: Response) => {
    const projectId = req.params.id as string;
    const orgId = req.user!.organizationId as string;

    // Find all users in this org that have a role in this project
    const users = await userRepository.findMany({ 
      'memberships': {
        $elemMatch: { 
          organizationId: new Types.ObjectId(orgId),
          'projectRoles.projectId': new Types.ObjectId(projectId)
        }
      }
    });
    
    const members = users.map(user => {
      const membership = user.memberships.find(m => m.organizationId.toString() === orgId);
      const projectRole = membership?.projectRoles.find(p => p.projectId.toString() === projectId);
      return {
        id: user._id,
        name: user.name,
        email: user.email,
        projectRole: projectRole?.role,
      };
    });

    ApiResponse.success(res, members, 'Project members retrieved');
  });

  addProjectMember = asyncHandler(async (req: Request, res: Response) => {
    const projectId = req.params.id as string;
    const orgId = req.user!.organizationId as string;
    const { email, role } = req.body;

    if (!Object.values(ProjectRole).includes(role)) {
      return ApiResponse.error(res, 'Invalid project role', null, 400);
    }

    const targetUser = await userService.getByEmail(email);
    if (!targetUser) {
      return ApiResponse.error(res, 'User with this email not found', null, 404);
    }

    const membership = targetUser.memberships.find(m => m.organizationId.toString() === orgId);
    if (!membership) {
      return ApiResponse.error(res, 'User must be a member of the organization first', null, 400);
    }

    const existingProjectRole = membership.projectRoles.find(p => p.projectId.toString() === projectId);
    if (existingProjectRole) {
      return ApiResponse.error(res, 'User is already a member of this project', null, 400);
    }

    membership.projectRoles.push({
      projectId: new Types.ObjectId(projectId),
      role: role
    });

    await userRepository.update(targetUser._id!.toString(), { memberships: targetUser.memberships });
    await auditService.logAction(orgId, 'PROJECT_MEMBER_ADDED', 'USER', targetUser._id!.toString(), req.user!.id, projectId);

    ApiResponse.success(res, { id: targetUser._id, name: targetUser.name, projectRole: role }, 'Project member added successfully');
  });

  updateProjectRole = asyncHandler(async (req: Request, res: Response) => {
    const projectId = req.params.id as string;
    const orgId = req.user!.organizationId as string;
    const userId = req.params.userId as string;
    const { role } = req.body;

    if (!Object.values(ProjectRole).includes(role)) {
      return ApiResponse.error(res, 'Invalid project role', null, 400);
    }

    const targetUser = await userRepository.findById(userId);
    if (!targetUser) {
      return ApiResponse.error(res, 'User not found', null, 404);
    }

    const membership = targetUser.memberships.find(m => m.organizationId.toString() === orgId);
    if (!membership) {
      return ApiResponse.error(res, 'User is not a member of this organization', null, 400);
    }

    const projectRoleObj = membership.projectRoles.find(p => p.projectId.toString() === projectId);
    if (!projectRoleObj) {
      return ApiResponse.error(res, 'User is not a member of this project', null, 400);
    }

    projectRoleObj.role = role;
    await userRepository.update(userId, { memberships: targetUser.memberships });
    await auditService.logAction(orgId, 'PROJECT_MEMBER_ROLE_UPDATED', 'USER', userId, req.user!.id, projectId);

    ApiResponse.success(res, null, 'Project role updated successfully');
  });

  removeProjectMember = asyncHandler(async (req: Request, res: Response) => {
    const projectId = req.params.id as string;
    const orgId = req.user!.organizationId as string;
    const userId = req.params.userId as string;

    const targetUser = await userRepository.findById(userId);
    if (!targetUser) {
      return ApiResponse.error(res, 'User not found', null, 404);
    }

    const membership = targetUser.memberships.find(m => m.organizationId.toString() === orgId);
    if (!membership) {
      return ApiResponse.error(res, 'User is not a member of this organization', null, 400);
    }

    const roleIndex = membership.projectRoles.findIndex(p => p.projectId.toString() === projectId);
    if (roleIndex === -1) {
      return ApiResponse.error(res, 'User is not a member of this project', null, 400);
    }

    membership.projectRoles.splice(roleIndex, 1);
    await userRepository.update(userId, { memberships: targetUser.memberships });
    await auditService.logAction(orgId, 'PROJECT_MEMBER_REMOVED', 'USER', userId, req.user!.id, projectId);

    ApiResponse.success(res, null, 'Project member removed successfully');
  });
}

export const memberController = new MemberController();
