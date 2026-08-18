import 'package:dio/dio.dart';
import '../models/project_model.dart';

class ProjectRemoteDataSource {
  final Dio _dio;

  ProjectRemoteDataSource(this._dio);

  Future<List<ProjectModel>> getAllProjects() async {
    final response = await _dio.get('/projects');
    return (response.data['data'] as List)
        .map((e) => ProjectModel.fromJson(e))
        .toList();
  }

  Future<ProjectModel> getProjectById(String id) async {
    final response = await _dio.get('/projects/$id');
    return ProjectModel.fromJson(response.data['data']);
  }

  Future<ProjectModel> createProject(String name, String? description) async {
    final response = await _dio.post(
      '/projects',
      data: {'name': name, 'description': description},
    );
    return ProjectModel.fromJson(response.data['data']);
  }

  Future<ProjectModel> updateProject(String id, String? name, String? description) async {
    final response = await _dio.patch(
      '/projects/$id',
      data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
      },
    );
    return ProjectModel.fromJson(response.data['data']);
  }

  Future<void> deleteProject(String id) async {
    await _dio.delete('/projects/$id');
  }
}
