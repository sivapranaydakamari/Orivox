import { Request, Response } from 'express';
import { authService } from '../service/auth.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';
import { auditService } from '../../audit/service/audit.service';

export class AuthController {
  private extractDeviceMetadata(req: Request) {
    return {
      deviceName: req.headers['x-device-name'] as string,
      platform: req.headers['x-platform'] as string,
      appVersion: req.headers['x-app-version'] as string,
      ipAddress: req.ip,
    };
  }

  login = asyncHandler(async (req: Request, res: Response) => {
    const deviceMetadata = this.extractDeviceMetadata(req);
    const loginData = { ...req.body, ...deviceMetadata };

    const { accessToken, refreshToken, user } = await authService.login(loginData);
    
    const organizationId = user.memberships.length > 0 ? user.memberships[0].organizationId.toString() : '';

    // Audit Log
    if (organizationId) {
      await auditService.logAction(organizationId, 'LOGIN', 'USER', user._id.toString(), user._id.toString(), undefined, deviceMetadata);
    }

    // Return tokens in JSON for Flutter
    ApiResponse.success(res, { accessToken, refreshToken, user }, 'Logged in successfully');
  });

  register = asyncHandler(async (req: Request, res: Response) => {
    // In a real app, registration might not create a session directly without device metadata,
    // but assuming this also comes from mobile.
    const deviceMetadata = this.extractDeviceMetadata(req);
    const registerData = { ...req.body, ...deviceMetadata };

    const { accessToken, refreshToken, user } = await authService.register(registerData);

    ApiResponse.success(res, { accessToken, refreshToken, user }, 'Registered successfully', 201);
  });

  refresh = asyncHandler(async (req: Request, res: Response) => {
    const { refreshToken } = req.body;
    if (!refreshToken) {
      return ApiResponse.error(res, 'Refresh token missing', null, 401);
    }

    const deviceMetadata = this.extractDeviceMetadata(req);
    const tokens = await authService.refreshTokens(refreshToken, deviceMetadata);

    ApiResponse.success(res, { accessToken: tokens.accessToken, refreshToken: tokens.refreshToken }, 'Tokens refreshed successfully');
  });

  logout = asyncHandler(async (req: Request, res: Response) => {
    const { refreshToken } = req.body;
    if (refreshToken) {
      await authService.logout(refreshToken);
    }
    ApiResponse.success(res, null, 'Logged out successfully');
  });

  getSessions = asyncHandler(async (req: Request, res: Response) => {
    if (!req.user) return ApiResponse.error(res, 'Unauthorized', null, 401);
    const sessions = await authService.getSessions(req.user.id);
    ApiResponse.success(res, sessions, 'Sessions retrieved successfully');
  });

  logoutAll = asyncHandler(async (req: Request, res: Response) => {
    if (!req.user) return ApiResponse.error(res, 'Unauthorized', null, 401);
    await authService.logoutAll(req.user.id, req.user.sessionId);
    ApiResponse.success(res, null, 'All other sessions logged out successfully');
  });

  resetPassword = asyncHandler(async (req: Request, res: Response) => {
    await authService.resetPassword(req.body);
    ApiResponse.success(res, null, 'Password reset successfully');
  });
}

export const authController = new AuthController();
