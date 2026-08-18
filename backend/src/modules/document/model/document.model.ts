import mongoose, { Document, Schema, Types } from 'mongoose';

export enum DocumentSourceType {
  GITHUB = 'GITHUB',
  MARKDOWN = 'MARKDOWN',
  POSTMAN = 'POSTMAN',
  DECISION_LOG = 'DECISION_LOG',
}

export enum DocumentStatus {
  PENDING = 'PENDING',
  EXTRACTING = 'EXTRACTING',
  EXTRACTED = 'EXTRACTED',
  FAILED = 'FAILED',
}

export interface IDocument extends Document {
  organizationId: Types.ObjectId;
  projectId: Types.ObjectId;
  sourceType: DocumentSourceType;
  externalId?: string;
  title: string;
  rawContent: string;
  metadata?: Record<string, unknown>;
  status: DocumentStatus;
  uploadedBy?: Types.ObjectId;
  createdBy?: Types.ObjectId;
  updatedBy?: Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const DocumentSchema: Schema = new Schema(
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
    },
    sourceType: {
      type: String,
      enum: Object.values(DocumentSourceType),
      required: true,
    },
    externalId: {
      type: String,
      index: true,
    },
    title: {
      type: String,
      required: true,
      trim: true,
      maxlength: 255,
    },
    rawContent: {
      type: String,
      required: true,
    },
    metadata: {
      type: Schema.Types.Mixed,
    },
    status: {
      type: String,
      enum: Object.values(DocumentStatus),
      default: DocumentStatus.PENDING,
    },
    uploadedBy: {
      type: Schema.Types.ObjectId,
      ref: 'User',
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

// For background workers finding pending documents
DocumentSchema.index({ projectId: 1, status: 1 });
DocumentSchema.index({ projectId: 1, sourceType: 1, externalId: 1 }, { unique: true });

export const DocumentModel = mongoose.model<IDocument>('Document', DocumentSchema);
