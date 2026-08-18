import '../../domain/repositories/project_repository.dart';
import '../../domain/entities/project.dart';
import '../datasources/project_remote_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource _remoteDataSource;

  ProjectRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Project>> getAllProjects() async {
    final models = await _remoteDataSource.getAllProjects();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Project> getProjectById(String id) async {
    final model = await _remoteDataSource.getProjectById(id);
    return model.toEntity();
  }

  @override
  Future<Project> createProject(String name, String? description) async {
    final model = await _remoteDataSource.createProject(name, description);
    return model.toEntity();
  }

  @override
  Future<Project> updateProject(String id, String? name, String? description) async {
    final model = await _remoteDataSource.updateProject(id, name, description);
    return model.toEntity();
  }

  @override
  Future<void> deleteProject(String id) async {
    await _remoteDataSource.deleteProject(id);
  }
}
