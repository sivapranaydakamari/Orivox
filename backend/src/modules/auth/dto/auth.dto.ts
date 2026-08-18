export interface LoginDto {
  email: string;
  password?: string; // Optional if using OAuth in the future
}

export interface RegisterDto {
  inviteToken: string;
  name: string;
  password?: string; // Optional if using OAuth
}

export interface ResetPasswordDto {
  resetToken: string;
  newPassword: string;
}

export interface RefreshDto {
  refreshToken: string;
}

export interface LogoutDto {
  refreshToken: string;
}

export interface JwtPayload {
  userId: string;
  organizationId: string;
  sessionId: string;
}
