import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../data/datasources/project_remote_data_source.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/active_org_provider.dart';

final projectRemoteDataSourceProvider = Provider<ProjectRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProjectRemoteDataSource(dio);
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final remoteDataSource = ref.watch(projectRemoteDataSourceProvider);
  return ProjectRepositoryImpl(remoteDataSource);
});

final projectListProvider = AsyncNotifierProvider<ProjectListNotifier, List<Project>>(() {
  return ProjectListNotifier();
});

class ProjectListNotifier extends AsyncNotifier<List<Project>> {
  ProjectRepository get _repository => ref.read(projectRepositoryProvider);

  @override
  Future<List<Project>> build() async {
    final activeOrg = ref.watch(activeOrgProvider); // Invalidate on org switch
    if (activeOrg == null || activeOrg.isEmpty) return [];
    return await ref.watch(projectRepositoryProvider).getAllProjects();
  }

  Future<void> createProject(String name, String? description) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createProject(name, description);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProject(String id, String? name, String? description) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProject(id, name, description);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProject(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteProject(id);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
