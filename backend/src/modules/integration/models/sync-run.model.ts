import mongoose, { Document, Schema, Types } from 'mongoose';

export enum SyncRunStatus {
  IN_PROGRESS = 'IN_PROGRESS',
  SUCCESS = 'SUCCESS',
  FAILED = 'FAILED',
}

export interface ISyncRun extends Document {
  organizationId: Types.ObjectId;
  projectId: Types.ObjectId;
  repositoryId: Types.ObjectId;
  startedAt: Date;
  finishedAt?: Date;
  status: SyncRunStatus;
  documentsImported: number;
  documentsUpdated: number;
  failedDocuments: number;
  errorMessage?: string;
  createdAt: Date;
  updatedAt: Date;
}

const SyncRunSchema: Schema = new Schema(
  {
    organizationId: {
      type: Schema.Types.ObjectId,
      ref: 'Organization',
      required: true,
      index: true,
    },
    projectId: {
      type: Schema.Types.ObjectId,
      ref: 'Project',
      required: true,
      index: true,
    },
    repositoryId: {
      type: Schema.Types.ObjectId,
      ref: 'Repository',
      required: true,
      index: true,
    },
    startedAt: {
      type: Date,
      required: true,
    },
    finishedAt: {
      type: Date,
    },
    status: {
      type: String,
      enum: Object.values(SyncRunStatus),
      default: SyncRunStatus.IN_PROGRESS,
    },
    documentsImported: {
      type: Number,
      default: 0,
    },
    documentsUpdated: {
      type: Number,
      default: 0,
    },
    failedDocuments: {
      type: Number,
      default: 0,
    },
    errorMessage: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

// 30-day TTL index to automatically remove old sync logs
SyncRunSchema.index({ createdAt: 1 }, { expireAfterSeconds: 2592000 });

export const SyncRunModel = mongoose.model<ISyncRun>('SyncRun', SyncRunSchema);
