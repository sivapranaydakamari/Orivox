import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../../../core/storage/secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write('access_token', accessToken);
    await _secureStorage.write('refresh_token', refreshToken);
  }

  @override
  Future<User> login(String email, String password) async {
    final response = await _remoteDataSource.login(email, password);
    await _saveTokens(response.accessToken, response.refreshToken);
    return response.user.toEntity();
  }

  @override
  Future<User> register(String name, String email, String password) async {
    final response = await _remoteDataSource.register(name, email, password);
    await _saveTokens(response.accessToken, response.refreshToken);
    return response.user.toEntity();
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await _secureStorage.read('refresh_token');
      if (refreshToken != null) {
        await _remoteDataSource.logout(refreshToken);
      }
    } catch (e) {
      // Ignore errors on logout, just clear local tokens
    } finally {
      await _secureStorage.deleteAll();
    }
  }

  @override
  Future<User?> checkAuthStatus() async {
    final token = await _secureStorage.read('access_token');
    if (token == null) {
      return null;
    }
    
    try {
      final userModel = await _remoteDataSource.getProfile();
      return userModel.toEntity();
    } catch (e) {
      // Token might be expired or invalid
      return null;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    // Mocking the forgot password behavior as requested in the plan.
    await Future.delayed(const Duration(seconds: 1));
  }
}
