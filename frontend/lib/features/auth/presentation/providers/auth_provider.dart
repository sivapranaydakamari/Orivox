import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../../../core/network/dio_client.dart'; // Assume this exists
import '../../../../core/storage/secure_storage.dart';

// Providers for dependencies
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider); // Assuming a dioProvider exists
  return AuthRemoteDataSource(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final secureStorage = ref.watch(secureStorageProvider); // Assuming exists
  return AuthRepositoryImpl(remoteDataSource, secureStorage);
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final notifier = AuthNotifier(authRepository);
  
  final subscription = unauthenticatedEventStream.stream.listen((_) {
    notifier.forceUnauthenticated();
  });
  
  ref.onDispose(() {
    subscription.cancel();
  });
  
  return notifier;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState.initial());

  void forceUnauthenticated() {
    state = const AuthState.unauthenticated();
  }

  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.checkAuthStatus();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.register(name, email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _authRepository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> forgotPassword(String email) async {
    state = const AuthState.loading();
    try {
      await _authRepository.forgotPassword(email);
      // Stay unauthenticated but remove error/loading state
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
