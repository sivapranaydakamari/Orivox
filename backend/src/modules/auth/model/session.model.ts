import mongoose, { Document, Schema, Types } from 'mongoose';

export interface ISession extends Document {
  sessionId: string;
  userId: Types.ObjectId;
  hashedRefreshToken: string;
  deviceName?: string;
  platform?: string;
  appVersion?: string;
  ipAddress?: string;
  lastUsedAt: Date;
  expiresAt: Date;
  revoked: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const SessionSchema: Schema = new Schema(
  {
    sessionId: {
      type: String,
      required: true,
      unique: true,
      index: true,
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    hashedRefreshToken: {
      type: String,
      required: true,
    },
    deviceName: {
      type: String,
    },
    platform: {
      type: String,
    },
    appVersion: {
      type: String,
    },
    ipAddress: {
      type: String,
    },
    lastUsedAt: {
      type: Date,
      default: Date.now,
    },
    expiresAt: {
      type: Date,
      required: true,
      index: { expireAfterSeconds: 0 }, // Automatically delete when expired
    },
    revoked: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

export const SessionModel = mongoose.model<ISession>('Session', SessionSchema);
