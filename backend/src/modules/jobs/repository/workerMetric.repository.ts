import { WorkerMetricModel, IWorkerMetric } from '../model/workerMetric.model';

export class WorkerMetricRepository {
  async create(data: Partial<IWorkerMetric>): Promise<IWorkerMetric> {
    return WorkerMetricModel.create(data);
  }

  async findAll(): Promise<IWorkerMetric[]> {
    return WorkerMetricModel.find().sort({ createdAt: -1 }).limit(100);
  }
}

export const workerMetricRepository = new WorkerMetricRepository();
