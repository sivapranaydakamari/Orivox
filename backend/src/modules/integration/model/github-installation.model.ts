import mongoose, { Document, Schema, Types } from 'mongoose';

export enum GitHubInstallationStatus {
  ACTIVE = 'ACTIVE',
  SUSPENDED = 'SUSPENDED',
  DELETED = 'DELETED',
}

export interface IGitHubInstallation extends Document {
  organizationId: Types.ObjectId;
  installationId: number;
  githubAccountId: number;
  githubAccountLogin: string;
  githubAccountType: string;
  status: GitHubInstallationStatus;
  createdBy?: Types.ObjectId;
  updatedBy?: Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const GitHubInstallationSchema: Schema = new Schema(
  {
    organizationId: {
      type: Schema.Types.ObjectId,
      ref: 'Organization',
      required: true,
      index: true,
    },
    installationId: {
      type: Number,
      required: true,
      unique: true,
    },
    githubAccountId: {
      type: Number,
      required: true,
    },
    githubAccountLogin: {
      type: String,
      required: true,
      trim: true,
    },
    githubAccountType: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      enum: Object.values(GitHubInstallationStatus),
      default: GitHubInstallationStatus.ACTIVE,
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

// Allow an organization to have multiple installations if they have multiple github accounts, 
// but usually it's one-to-one or one-to-many. The installationId is globally unique.

export const GitHubInstallation = mongoose.model<IGitHubInstallation>('GitHubInstallation', GitHubInstallationSchema);
