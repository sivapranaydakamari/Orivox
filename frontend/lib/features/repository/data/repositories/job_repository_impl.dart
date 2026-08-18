import '../../domain/entities/job.dart';
import '../../domain/entities/worker_metric.dart';
import '../datasources/job_remote_data_source.dart';

class JobRepositoryImpl {
  final JobRemoteDataSource _remoteDataSource;

  JobRepositoryImpl(this._remoteDataSource);

  Future<JobStatus> getJobStatus(String id) => _remoteDataSource.getJobStatus(id);

  Future<List<WorkerMetric>> getMetrics() => _remoteDataSource.getMetrics();

  Future<void> retryJob(String id) => _remoteDataSource.retryJob(id);

  Future<Map<String, dynamic>> getSyncStatus(String repositoryId) => _remoteDataSource.getSyncStatus(repositoryId);
}
