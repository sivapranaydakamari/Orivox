import 'package:dio/dio.dart';
import '../models/repository_dto.dart';
import '../../domain/entities/repository.dart';

class RepositoryRemoteDataSource {
  final Dio _dio;

  RepositoryRemoteDataSource(this._dio);

  Future<List<Repository>> getRepositories() async {
    final response = await _dio.get('/repositories');
    final data = response.data['data'] as List;
    return data.map((json) => Repository.fromJson(json)).toList();
  }

  Future<Repository> getRepositoryById(String id) async {
    final response = await _dio.get('/repositories/$id');
    return Repository.fromJson(response.data['data']);
  }

  Future<Repository> createRepository(CreateRepositoryDto dto) async {
    final response = await _dio.post('/repositories', data: dto.toJson());
    return Repository.fromJson(response.data['data']);
  }

  Future<Repository> updateRepository(String id, UpdateRepositoryDto dto) async {
    final response = await _dio.patch('/repositories/$id', data: dto.toJson());
    return Repository.fromJson(response.data['data']);
  }

  Future<void> deleteRepository(String id) async {
    await _dio.delete('/repositories/$id');
  }

  Future<void> syncRepository(String id) async {
    // HTTP 202 async handling
    await _dio.post('/repositories/$id/sync');
  }

  Future<Map<String, dynamic>> generateWebhookSecret(String id) async {
    final response = await _dio.post('/repositories/$id/webhook-secret');
    return response.data['data'] as Map<String, dynamic>;
  }
}
