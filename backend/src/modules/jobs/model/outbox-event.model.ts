import mongoose, { Document, Schema } from 'mongoose';
import { JobType } from '../types/job.types';

export enum OutboxEventStatus {
  PENDING = 'PENDING',
  PROCESSED = 'PROCESSED',
  FAILED = 'FAILED',
}

export interface IOutboxEvent extends Document {
  jobType: JobType;
  payload: Record<string, unknown>;
  status: OutboxEventStatus;
  error?: string;
  createdAt: Date;
  updatedAt: Date;
}

const OutboxEventSchema: Schema = new Schema(
  {
    jobType: {
      type: String,
      enum: Object.values(JobType),
      required: true,
    },
    payload: {
      type: Schema.Types.Mixed,
      required: true,
    },
    status: {
      type: String,
      enum: Object.values(OutboxEventStatus),
      default: OutboxEventStatus.PENDING,
      index: true,
    },
    error: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

export const OutboxEventModel = mongoose.model<IOutboxEvent>('OutboxEvent', OutboxEventSchema);
