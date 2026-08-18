import { userRepository } from '../../user/repository/user.repository';
import { LoginDto, RegisterDto, ResetPasswordDto, JwtPayload } from '../dto/auth.dto';
import { IUser, AuthProvider } from '../../user/model/user.model';
import { ISession } from '../model/session.model';
import { sessionRepository } from '../repository/session.repository';
import bcrypt from 'bcrypt'; // Needs npm install bcrypt
import jwt from 'jsonwebtoken'; // Needs npm install jsonwebtoken
import crypto from 'crypto';
import { env } from '../../../config/env';

export class AuthService {
  private readonly jwtSecret = env.JWT_SECRET || 'fallback_secret_do_not_use_in_prod';
  private readonly jwtRefreshSecret = env.JWT_REFRESH_SECRET || 'fallback_refresh_secret';
  
  async login(dto: LoginDto): Promise<{ accessToken: string; refreshToken: string; user: IUser }> {
    const user = await userRepository.findOne({ email: dto.email });
    if (!user) {
      throw new Error('Invalid credentials');
    }

    if (user.authProvider === AuthProvider.EMAIL) {
      if (!dto.password || !user.passwordHash) {
        throw new Error('Invalid credentials');
      }
      
      const isMatch = await bcrypt.compare(dto.password, user.passwordHash);
      if (!isMatch) {
        throw new Error('Invalid credentials');
      }
    }

    const sessionId = crypto.randomUUID();
    
    // Default organization for the session (usually the first one, or can be passed during login)
    const organizationId = user.memberships.length > 0 ? user.memberships[0].organizationId.toString() : '';

    const payload: JwtPayload = {
      userId: user._id.toString(),
      organizationId,
      sessionId,
    };

    const accessToken = jwt.sign(payload, this.jwtSecret, { expiresIn: '15m' });
    const refreshToken = jwt.sign(payload, this.jwtRefreshSecret, { expiresIn: '7d' });

    // Hash refresh token for DB storage
    const hashedRefreshToken = await bcrypt.hash(refreshToken, 10);

    // Create session (Mobile Optimization)
    await sessionRepository.create({
      sessionId,
      userId: user._id,
      hashedRefreshToken,
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
      deviceName: (dto as unknown as Record<string, unknown>).deviceName as string,
      platform: (dto as unknown as Record<string, unknown>).platform as string,
      appVersion: (dto as unknown as Record<string, unknown>).appVersion as string,
      ipAddress: (dto as unknown as Record<string, unknown>).ipAddress as string,
    });

    return { accessToken, refreshToken, user };
  }

  async register(dto: RegisterDto): Promise<{ accessToken: string; refreshToken: string; user: IUser }> {
    const existingUser = await userRepository.findOne({ email: (dto as any).email });
    if (existingUser) {
      throw new Error('User already exists');
    }

    const passwordHash = dto.password ? await bcrypt.hash(dto.password, 10) : undefined;
    
    const user = await userRepository.create({
      email: (dto as any).email,
      name: dto.name,
      passwordHash,
      authProvider: AuthProvider.EMAIL,
      memberships: []
    });

    // Auto-login after registration
    return this.login({ email: user.email, password: dto.password });
  }

  async refreshTokens(refreshToken: string, deviceMetadata?: Record<string, unknown>): Promise<{ accessToken: string; refreshToken: string }> {
    try {
      const decoded = jwt.verify(refreshToken, this.jwtRefreshSecret) as JwtPayload;
      
      const session = await sessionRepository.findOne({ sessionId: decoded.sessionId });
      
      if (!session || session.revoked) {
        throw new Error('Session revoked or invalid');
      }

      if (new Date() > session.expiresAt) {
        throw new Error('Session expired');
      }

      const isValidToken = await bcrypt.compare(refreshToken, session.hashedRefreshToken);
      if (!isValidToken) {
        // Potential token theft: Revoke session immediately
        await sessionRepository.revokeSession(decoded.sessionId);
        throw new Error('Invalid refresh token signature');
      }

      const payload: JwtPayload = {
        userId: decoded.userId,
        organizationId: decoded.organizationId,
        sessionId: decoded.sessionId,
      };

      const newAccessToken = jwt.sign(payload, this.jwtSecret, { expiresIn: '15m' });
      const newRefreshToken = jwt.sign(payload, this.jwtRefreshSecret, { expiresIn: '7d' });

      const newHashedRefreshToken = await bcrypt.hash(newRefreshToken, 10);

      await sessionRepository.update(session._id.toString(), {
        hashedRefreshToken: newHashedRefreshToken,
        lastUsedAt: new Date(),
        ...(deviceMetadata || {}),
      });

      return { accessToken: newAccessToken, refreshToken: newRefreshToken };
    } catch (_err) {
      throw new Error('Invalid or expired refresh token');
    }
  }

  async logout(refreshToken: string): Promise<void> {
    try {
      // We don't verify expiry, just decode to get sessionId
      const decoded = jwt.decode(refreshToken) as JwtPayload | null;
      if (decoded && decoded.sessionId) {
        await sessionRepository.revokeSession(decoded.sessionId);
      }
    } catch (_e) {
      // Ignore errors on logout
    }
  }

  async getSessions(userId: string): Promise<ISession[]> {
    return sessionRepository.findMany({ userId, revoked: false });
  }

  async logoutAll(userId: string, currentSessionId: string): Promise<void> {
    const sessions = await sessionRepository.findMany({ userId, revoked: false });
    for (const session of sessions) {
      if (session.sessionId !== currentSessionId) {
        await sessionRepository.revokeSession(session.sessionId);
      }
    }
  }

  async resetPassword(dto: ResetPasswordDto): Promise<void> {
    const user = await userRepository.findOne({ resetToken: dto.resetToken });
    if (!user) {
      throw new Error('Invalid or expired reset token');
    }

    user.passwordHash = await bcrypt.hash(dto.newPassword, 10);
    user.resetToken = undefined;
    await user.save();
  }
}

export const authService = new AuthService();
