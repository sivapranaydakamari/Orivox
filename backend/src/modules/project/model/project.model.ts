import mongoose, { Document, Schema, Types } from 'mongoose';

export interface IProject extends Document {
  organizationId: Types.ObjectId;
  name: string;
  description?: string;
  createdBy?: Types.ObjectId;
  updatedBy?: Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const ProjectSchema: Schema = new Schema(
  {
    organizationId: {
      type: Schema.Types.ObjectId,
      ref: 'Organization',
      required: true,
      index: true,
    },
    name: {
      type: String,
      required: true,
      trim: true,
      minlength: 2,
      maxlength: 100,
    },
    description: {
      type: String,
      trim: true,
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

// Prevent duplicate project names within the same organization
ProjectSchema.index({ organizationId: 1, name: 1 }, { unique: true });

export const Project = mongoose.model<IProject>('Project', ProjectSchema);
