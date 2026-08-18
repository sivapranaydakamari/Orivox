import '../entities/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getAllProjects();
  Future<Project> getProjectById(String id);
  Future<Project> createProject(String name, String? description);
  Future<Project> updateProject(String id, String? name, String? description);
  Future<void> deleteProject(String id);
}
