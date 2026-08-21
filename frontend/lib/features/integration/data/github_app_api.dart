import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

final githubAppApiProvider = Provider<GitHubAppApi>((ref) {
  final dio = ref.watch(dioProvider);
  return GitHubAppApi(dio);
});

class GitHubAppApi {
  final Dio _dio;

  GitHubAppApi(this._dio);

  Future<String> getInstallUrl() async {
    final response = await _dio.get('/integrations/github/install');
    return response.data['data']['url'] as String;
  }

  Future<List<Map<String, dynamic>>> getInstallations() async {
    final response = await _dio.get('/integrations/github/installations');
    final data = response.data['data']['installations'] as List;
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getRepositories(String installationId) async {
    final response = await _dio.get('/integrations/github/installations/$installationId/repositories');
    final data = response.data['data']['repositories'] as List;
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getAllRepositories() async {
    final response = await _dio.get('/integrations/github/repositories');
    final data = response.data['data']['installations'] as List;
    return List<Map<String, dynamic>>.from(data);
  }
}
