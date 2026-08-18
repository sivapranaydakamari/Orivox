import { Request, Response } from 'express';
import { userService } from '../service/user.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';

export class UserController {
  getProfile = asyncHandler(async (req: Request, res: Response) => {
    if (!req.user) return ApiResponse.error(res, 'Unauthorized', null, 401);
    const user = await userService.getProfile(req.user.id);
    ApiResponse.success(res, user, 'Profile retrieved successfully');
  });

  updateProfile = asyncHandler(async (req: Request, res: Response) => {
    if (!req.user) return ApiResponse.error(res, 'Unauthorized', null, 401);
    const { name } = req.body;
    if (!name || name.trim() === '') {
      return ApiResponse.error(res, 'Name is required', null, 400);
    }
    const updatedUser = await userService.updateProfile(req.user.id, name);
    ApiResponse.success(res, updatedUser, 'Profile updated successfully');
  });

  changePassword = asyncHandler(async (req: Request, res: Response) => {
    if (!req.user) return ApiResponse.error(res, 'Unauthorized', null, 401);
    const { currentPassword, newPassword } = req.body;
    await userService.changePassword(req.user.id, currentPassword, newPassword);
    ApiResponse.success(res, null, 'Password changed successfully');
  });
}

export const userController = new UserController();
