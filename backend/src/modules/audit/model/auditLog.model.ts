import mongoose, { Document, Schema, Types } from 'mongoose';

export interface IAuditLog extends Document {
  organizationId: Types.ObjectId;
  projectId?: Types.ObjectId;
  userId?: Types.ObjectId;
  action: string;
  resourceType: string;
  resourceId?: string;
  metadata?: Record<string, unknown>;
  createdAt: Date;
}

const AuditLogSchema: Schema = new Schema(
  {
    organizationId: {
      type: Schema.Types.ObjectId,
      ref: 'Organization',
      required: true,
    },
    projectId: {
      type: Schema.Types.ObjectId,
      ref: 'Project',
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
    },
    action: {
      type: String,
      required: true,
      trim: true,
    },
    resourceType: {
      type: String,
      required: true,
      trim: true,
    },
    resourceId: {
      type: String,
    },
    metadata: {
      type: Schema.Types.Mixed,
    },
  },
  {
    timestamps: { createdAt: true, updatedAt: false }, // Immutable, so no updatedAt
  }
);

// For dashboards fetching audit logs for an org in descending order
AuditLogSchema.index({ organizationId: 1, createdAt: -1 });

// For querying specific user behavior
AuditLogSchema.index({ userId: 1 });

// Optional: 1-year TTL for cost-saving
AuditLogSchema.index({ createdAt: 1 }, { expireAfterSeconds: 31536000 });

export const AuditLog = mongoose.model<IAuditLog>('AuditLog', AuditLogSchema);
