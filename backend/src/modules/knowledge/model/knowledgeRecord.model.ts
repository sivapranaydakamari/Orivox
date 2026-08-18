import mongoose, { Document, Schema, Types } from 'mongoose';

export enum SourceType {
  GITHUB = 'GITHUB',
  GITHUB_PR = 'GITHUB_PR',
  MARKDOWN = 'MARKDOWN',
  POSTMAN = 'POSTMAN',
  DECISION_LOG = 'DECISION_LOG',
}

export enum ConfidenceLevel {
  HIGH = 'HIGH',
  MEDIUM = 'MEDIUM',
  LOW = 'LOW',
  NONE = 'NONE',
}

export enum EmbeddingStatus {
  PENDING = 'PENDING',
  EMBEDDING = 'EMBEDDING',
  EMBEDDED = 'EMBEDDED',
  FAILED = 'FAILED',
}

export interface IKnowledgeRecord extends Document {
  organizationId: Types.ObjectId;
  projectId: Types.ObjectId;
  sourceType: SourceType;
  sourceReferenceId: Types.ObjectId | string;
  title: string;
  summary: string;
  technicalDecisions: string[];
  businessContext: string;
  risks: string[];
  breakingChanges: string[];
  dependencies: string[];
  affectedComponents: string[];
  referencedApis: string[];
  engineeringReasoning?: string;
  author?: string;
  tags: string[];
  confidence: ConfidenceLevel | number;
  embedding?: number[];
  embeddingStatus: EmbeddingStatus;
  embeddingModel?: string;
  embeddingVersion?: number;
  embeddingCreatedAt?: Date;
  knowledgeVersion: number;
  promptVersion?: string;
  modelName?: string;
  modelVersion?: string;
  metadata?: Record<string, unknown>;
  documentId?: Types.ObjectId;
  createdBy?: Types.ObjectId;
  updatedBy?: Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const KnowledgeRecordSchema: Schema = new Schema(
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
    sourceType: {
      type: String,
      enum: Object.values(SourceType),
      required: true,
    },
    sourceReferenceId: {
      type: Schema.Types.Mixed,
      required: true,
    },
    title: {
      type: String,
      required: true,
      trim: true,
      maxlength: 255,
    },
    summary: {
      type: String,
      required: true,
      trim: true,
      // Constrained to ~300 words logically, mapped to max length here
      maxlength: 3000,
    },
    engineeringReasoning: {
      type: String,
      trim: true,
    },
    technicalDecisions: [
      {
        type: String,
      },
    ],
    businessContext: {
      type: String,
    },
    risks: [
      {
        type: String,
      },
    ],
    breakingChanges: [
      {
        type: String,
      },
    ],
    dependencies: [
      {
        type: String,
      },
    ],
    affectedComponents: [
      {
        type: String,
        trim: true,
      },
    ],
    referencedApis: [
      {
        type: String,
      },
    ],
    author: {
      type: String,
      trim: true,
    },
    tags: [
      {
        type: String,
        trim: true,
        index: true,
      },
    ],
    confidence: {
      type: Schema.Types.Mixed,
      default: ConfidenceLevel.MEDIUM,
    },
    embedding: {
      type: [Number],
      default: undefined,
      validate: {
        validator: function (v: number[]) {
          if (!v || v.length === 0) return true;
          return v.length > 0;
        },
        message: 'Embedding vector cannot be empty.',
      },
      required: false,
    },
    embeddingStatus: {
      type: String,
      enum: Object.values(EmbeddingStatus),
      default: EmbeddingStatus.PENDING,
    },
    knowledgeVersion: {
      type: Number,
      default: 1,
      required: true,
    },
    promptVersion: {
      type: String,
    },
    modelName: {
      type: String,
    },
    modelVersion: {
      type: String,
    },
    metadata: {
      type: Schema.Types.Mixed,
    },
    embeddingModel: {
      type: String,
    },
    embeddingVersion: {
      type: Number,
    },
    embeddingCreatedAt: {
      type: Date,
    },
    documentId: {
      type: Schema.Types.ObjectId,
      ref: 'Document',
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

KnowledgeRecordSchema.index({ organizationId: 1, projectId: 1 });
KnowledgeRecordSchema.index({ documentId: 1, sourceReferenceId: 1 }, { unique: true });

export const KnowledgeRecord = mongoose.model<IKnowledgeRecord>('KnowledgeRecord', KnowledgeRecordSchema);
