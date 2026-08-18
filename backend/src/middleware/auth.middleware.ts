import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { ApiResponse } from '../shared/utils/apiResponse';
import { env } from '../config/env';
import { userRepository } from '../modules/user/repository/user.repository';
import { OrgRole, ProjectRole } from '../modules/user/model/user.model';
import { JwtPayload } from '../modules/auth/dto/auth.dto';

// Extend Express Request to include user
declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      user?: {
        id: string;
        organizationId: string;
        sessionId: string;
      };
    }
  }
}

export const requireAuth = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return ApiResponse.error(res, 'Authentication required', null, 401);
  }

  const token = authHeader.split(' ')[1];
  try {
    const payload = jwt.verify(token, env.JWT_SECRET || 'fallback_secret_do_not_use_in_prod') as JwtPayload;
    const headerOrgId = req.headers['x-organization-id'] as string;
    req.user = {
      id: payload.userId,
      organizationId: headerOrgId || payload.organizationId,
      sessionId: payload.sessionId,
    };
    next();
  } catch (_error) {
    return ApiResponse.error(res, 'Invalid or expired token', null, 401);
  }
};

export const requireOrganization = async (req: Request, res: Response, next: NextFunction) => {
  if (!req.user || !req.user.organizationId) {
    return ApiResponse.error(res, 'Organization context required', null, 403);
  }

  try {
    const user = await userRepository.findById(req.user.id);
    if (!user) {
      return ApiResponse.error(res, 'User not found', null, 401);
    }

    const orgMembership = user.memberships.find(m => m.organizationId.toString() === req.user!.organizationId);
    if (!orgMembership) {
      return ApiResponse.error(res, 'Access denied to organization', null, 403);
    }
    
    next();
  } catch (_error) {
    return ApiResponse.error(res, 'Authorization error', null, 500);
  }
};

export const requireOrgRole = (allowedRoles: OrgRole[]) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user || !req.user.organizationId) {
        return ApiResponse.error(res, 'Organization context required', null, 403);
      }
      const user = await userRepository.findById(req.user.id);
      if (!user) return ApiResponse.error(res, 'User not found', null, 401);

      const orgMembership = user.memberships.find(m => m.organizationId.toString() === req.user!.organizationId);
      if (!orgMembership) {
        return ApiResponse.error(res, 'Access denied to organization', null, 403);
      }

      if (!allowedRoles.includes(orgMembership.orgRole)) {
        return ApiResponse.error(res, 'Insufficient organization permissions', null, 403);
      }

      next();
    } catch (_error) {
      return ApiResponse.error(res, 'Authorization error', null, 500);
    }
  };
};

const getProjectIdFromRequest = (req: Request): string | undefined => {
  return req.params.projectId || req.body.projectId || req.query.projectId as string | undefined;
};

export const requireProjectAccess = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const projectId = getProjectIdFromRequest(req);
    if (!projectId) {
      return ApiResponse.error(res, 'Project ID required for this action', null, 400);
    }

    const user = await userRepository.findById(req.user!.id);
    if (!user) return ApiResponse.error(res, 'User not found', null, 401);

    const orgMembership = user.memberships.find(m => m.organizationId.toString() === req.user!.organizationId);
    if (!orgMembership) {
      return ApiResponse.error(res, 'Access denied to organization', null, 403);
    }

    // Org Admins have access to all projects
    if (orgMembership.orgRole === OrgRole.ORG_ADMIN) {
      return next();
    }

    const projectAccess = orgMembership.projectRoles.find(p => p.projectId.toString() === projectId);
    if (!projectAccess) {
      return ApiResponse.error(res, 'Access denied to project', null, 403);
    }

    next();
  } catch (_error) {
    return ApiResponse.error(res, 'Authorization error', null, 500);
  }
};

export const requireRole = (allowedRoles: ProjectRole[]) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const projectId = getProjectIdFromRequest(req);
      if (!projectId) {
        return ApiResponse.error(res, 'Project ID required for role validation', null, 400);
      }

      const user = await userRepository.findById(req.user!.id);
      if (!user) return ApiResponse.error(res, 'User not found', null, 401);

      const orgMembership = user.memberships.find(m => m.organizationId.toString() === req.user!.organizationId);
      if (!orgMembership) {
        return ApiResponse.error(res, 'Access denied to organization', null, 403);
      }

      // Org Admins bypass project role checks
      if (orgMembership.orgRole === OrgRole.ORG_ADMIN) {
        return next();
      }

      const projectRoleObj = orgMembership.projectRoles.find(p => p.projectId.toString() === projectId);
      if (!projectRoleObj || !allowedRoles.includes(projectRoleObj.role)) {
        return ApiResponse.error(res, 'Insufficient project permissions', null, 403);
      }

      next();
    } catch (_error) {
      return ApiResponse.error(res, 'Authorization error', null, 500);
    }
  };
};
