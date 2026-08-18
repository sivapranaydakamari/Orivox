import { SessionModel, ISession } from '../model/session.model';
import mongoose from 'mongoose';

export class SessionRepository {
  async create(data: Partial<ISession>): Promise<ISession> {
    return SessionModel.create(data);
  }

  async findOne(query: Record<string, unknown>): Promise<ISession | null> {
    return SessionModel.findOne(query);
  }

  async findMany(query: Record<string, unknown>): Promise<ISession[]> {
    return SessionModel.find(query).sort({ lastUsedAt: -1 });
  }

  async update(id: string, update: mongoose.UpdateQuery<ISession>): Promise<ISession | null> {
    return SessionModel.findByIdAndUpdate(id, update, { new: true });
  }

  async revokeSession(sessionId: string): Promise<void> {
    await SessionModel.findOneAndUpdate({ sessionId }, { revoked: true, hashedRefreshToken: '' });
  }

  async revokeAllUserSessions(userId: string): Promise<void> {
    await SessionModel.updateMany({ userId }, { revoked: true, hashedRefreshToken: '' });
  }
}

export const sessionRepository = new SessionRepository();
