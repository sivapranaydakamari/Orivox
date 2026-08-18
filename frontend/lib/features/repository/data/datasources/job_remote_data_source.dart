import 'package:dio/dio.dart';
import '../../domain/entities/job.dart';
import '../../domain/entities/worker_metric.dart';

class JobRemoteDataSource {
  final Dio _dio;

  JobRemoteDataSource(this._dio);

  Future<JobStatus> getJobStatus(String id) async {
    final response = await _dio.get('/jobs/$id');
    return JobStatus.fromJson(response.data['data']);
  }

  Future<List<WorkerMetric>> getMetrics() async {
    final response = await _dio.get('/jobs/metrics');
    final data = response.data['data'] as List;
    return data.map((json) => WorkerMetric.fromJson(json)).toList();
  }

  Future<void> retryJob(String id) async {
    await _dio.post('/jobs/$id/retry');
  }

  Future<Map<String, dynamic>> getSyncStatus(String repositoryId) async {
    final response = await _dio.get('/repositories/$repositoryId/sync-status');
    return response.data['data'] as Map<String, dynamic>;
  }
}
