import mongoose, { Document, Schema } from 'mongoose';

export interface IWorkerMetric extends Document {
  workerName: string;
  jobId: string;
  startedAt: Date;
  finishedAt: Date;
  duration: number; // in milliseconds
  retryCount: number;
  failureReason?: string;
  createdAt: Date;
}

const WorkerMetricSchema: Schema = new Schema(
  {
    workerName: { type: String, required: true, index: true },
    jobId: { type: String, required: true, index: true },
    startedAt: { type: Date, required: true },
    finishedAt: { type: Date, required: true },
    duration: { type: Number, required: true },
    retryCount: { type: Number, default: 0 },
    failureReason: { type: String },
  },
  {
    timestamps: { createdAt: true, updatedAt: false },
  }
);

export const WorkerMetricModel = mongoose.model<IWorkerMetric>('WorkerMetric', WorkerMetricSchema);
