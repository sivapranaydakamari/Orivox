import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/auth/domain/entities/user.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_models.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(ref.watch(dioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepositoryImpl>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider));
});

final profileProvider = FutureProvider.autoDispose<User>((ref) {
  return ref.watch(profileRepositoryProvider).getProfile();
});

final sessionsProvider = FutureProvider.autoDispose<List<Session>>((ref) {
  return ref.watch(profileRepositoryProvider).getSessions();
});

class ProfileActionNotifier extends StateNotifier<AsyncValue<void>> {
  final ProfileRepositoryImpl _repository;
  final Ref _ref;

  ProfileActionNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> updateProfile(String name) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProfile(name);
      _ref.invalidate(profileProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    state = const AsyncValue.loading();
    try {
      await _repository.changePassword(currentPassword, newPassword);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logoutAllDevices() async {
    state = const AsyncValue.loading();
    try {
      await _repository.logoutAllDevices();
      _ref.invalidate(sessionsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final profileActionProvider = StateNotifierProvider<ProfileActionNotifier, AsyncValue<void>>((ref) {
  return ProfileActionNotifier(ref.watch(profileRepositoryProvider), ref);
});
