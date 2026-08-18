import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/repository_remote_data_source.dart';
import '../../data/repositories/repository_repository_impl.dart';
import '../../domain/entities/repository.dart';
import '../../data/models/repository_dto.dart';
import 'job_providers.dart';

final repositoryRemoteDataSourceProvider = Provider<RepositoryRemoteDataSource>((ref) {
  return RepositoryRemoteDataSource(ref.watch(dioProvider));
});

final repositoryRepositoryProvider = Provider<RepositoryRepositoryImpl>((ref) {
  return RepositoryRepositoryImpl(ref.watch(repositoryRemoteDataSourceProvider));
});

final repositoryListProvider = FutureProvider.family<List<Repository>, String?>((ref, projectId) async {
  final repository = ref.watch(repositoryRepositoryProvider);
  final repos = await repository.getRepositories();
  if (projectId != null) {
    return repos.where((repo) => repo.projectId == projectId).toList();
  }
  return repos;
});

final repositoryDetailsProvider = FutureProvider.family<Repository, String>((ref, id) async {
  return ref.watch(repositoryRepositoryProvider).getRepositoryById(id);
});

class RepositoryActionNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<Repository> createRepository(CreateRepositoryDto dto) async {
    state = const AsyncValue.loading();
    try {
      final repository = await ref.read(repositoryRepositoryProvider).createRepository(dto);
      ref.invalidate(repositoryListProvider);
      state = const AsyncValue.data(null);
      return repository;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateRepository(String id, UpdateRepositoryDto dto) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(repositoryRepositoryProvider).updateRepository(id, dto);
      ref.invalidate(repositoryListProvider);
      ref.invalidate(repositoryDetailsProvider(id));
    });
  }

  Future<void> deleteRepository(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(repositoryRepositoryProvider).deleteRepository(id);
      ref.invalidate(repositoryListProvider);
    });
  }

  Future<void> syncRepository(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(repositoryRepositoryProvider).syncRepository(id);
      ref.invalidate(repositoryListProvider);
      ref.invalidate(repositoryDetailsProvider(id));
      ref.invalidate(syncPollingProvider(id));
    });
  }

  Future<Map<String, dynamic>> generateWebhookSecret(String id) async {
    state = const AsyncValue.loading();
    try {
      final data = await ref.read(repositoryRepositoryProvider).generateWebhookSecret(id);
      ref.invalidate(repositoryDetailsProvider(id));
      state = const AsyncValue.data(null);
      return data;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final repositoryActionProvider = NotifierProvider.autoDispose<RepositoryActionNotifier, AsyncValue<void>>(() {
  return RepositoryActionNotifier();
});
