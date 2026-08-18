import mongoose, { Document, Schema, Types } from 'mongoose';

export enum SyncStatus {
  NOT_CONFIGURED = 'NOT_CONFIGURED',
  CONNECTED = 'CONNECTED',
  SYNCING = 'SYNCING',
  PROCESSING = 'PROCESSING',
  SUCCESS = 'SUCCESS',
  FAILED = 'FAILED',
}

export enum SyncMode {
  MANUAL = 'MANUAL',
  AUTOMATIC = 'AUTOMATIC',
}

export enum WebhookStatus {
  NOT_CONFIGURED = 'NOT_CONFIGURED',
  PENDING = 'PENDING',
  ACTIVE = 'ACTIVE',
  FAILED = 'FAILED',
  DISABLED = 'DISABLED',
}

export interface IRepository extends Document {
  organizationId: Types.ObjectId;
  projectId: Types.ObjectId;
  provider: string;
  repositoryUrl: string;
  repositoryName: string;
  isActive: boolean;
  
  // Credentials
  providerToken?: string;
  webhookSecret?: string;

  // GitHub App Integration
  githubInstallationId?: Types.ObjectId;
  githubRepositoryId?: number;
  githubRepositoryFullName?: string;
  sourceConfiguration?: {
    code: boolean;
    docs: boolean;
    prs: boolean;
  };

  // Configuration
  syncMode: SyncMode;
  webhookStatus: WebhookStatus;

  // Status Machine
  syncStatus: SyncStatus;
  syncLockedAt?: Date;
  syncLockedBy?: string;
  
  // Sync State & Metrics
  lastSyncStartedAt?: Date;
  lastSyncCompletedAt?: Date;
  lastSuccessfulSync?: Date;
  lastProcessedPullRequest?: number;
  lastProcessedCommitSha?: string;
  
  filesAdded?: number;
  filesModified?: number;
  filesDeleted?: number;
  prsProcessed?: number;

  syncError?: string;
  
  createdBy?: Types.ObjectId;
  updatedBy?: Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const RepositorySchema: Schema = new Schema(
  {
    organizationId: {
      type: Schema.Types.ObjectId,
      ref: 'Organization',
      required: true,
    },
    projectId: {
      type: Schema.Types.ObjectId,
      ref: 'Project',
      required: true,
      index: true,
    },
    provider: {
      type: String,
      required: true,
      default: 'GITHUB',
    },
    repositoryUrl: {
      type: String,
      required: true,
      trim: true,
      match: /^(https?:\/\/)?(www\.)?github\.com\/[a-zA-Z0-9_.-]+\/[a-zA-Z0-9_.-]+$/,
    },
    repositoryName: {
      type: String,
      required: true,
      trim: true,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    providerToken: {
      type: String,
    },
    webhookSecret: {
      type: String,
    },
    syncMode: {
      type: String,
      enum: Object.values(SyncMode),
      default: SyncMode.AUTOMATIC,
    },
    webhookStatus: {
      type: String,
      enum: Object.values(WebhookStatus),
      default: WebhookStatus.NOT_CONFIGURED,
    },
    githubInstallationId: {
      type: Schema.Types.ObjectId,
      ref: 'GitHubInstallation',
    },
    githubRepositoryId: {
      type: Number,
    },
    githubRepositoryFullName: {
      type: String,
      trim: true,
    },
    sourceConfiguration: {
      code: { type: Boolean, default: true },
      docs: { type: Boolean, default: true },
      prs: { type: Boolean, default: false },
    },
    syncStatus: {
      type: String,
      enum: Object.values(SyncStatus),
      default: SyncStatus.NOT_CONFIGURED,
    },
    syncLockedAt: {
      type: Date,
    },
    syncLockedBy: {
      type: String,
    },
    lastSyncStartedAt: { type: Date },
    lastSyncCompletedAt: { type: Date },
    lastSuccessfulSync: { type: Date },
    lastProcessedPullRequest: { type: Number },
    lastProcessedCommitSha: { type: String },
    
    filesAdded: { type: Number, default: 0 },
    filesModified: { type: Number, default: 0 },
    filesDeleted: { type: Number, default: 0 },
    prsProcessed: { type: Number, default: 0 },

    syncError: {
      type: String,
    },
    createdBy: {
      type: Schema.Types.ObjectId,
      ref: 'User',
    },
    updatedBy: {
      type: Schema.Types.ObjectId,
      ref: 'User',
    },
  },
  {
    timestamps: true,
  }
);

// Prevent connecting the same repository multiple times to the same project
RepositorySchema.index({ projectId: 1, repositoryUrl: 1 }, { unique: true });
RepositorySchema.index({ projectId: 1, githubRepositoryId: 1 }, { unique: true, sparse: true });

export const Repository = mongoose.model<IRepository>('Repository', RepositorySchema);
