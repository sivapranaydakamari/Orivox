import '../../../../features/auth/domain/entities/user.dart';
import '../../domain/entities/profile_models.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  Future<User> getProfile() => _remoteDataSource.getProfile();
  
  Future<User> updateProfile(String name) => _remoteDataSource.updateProfile(name);
  
  Future<void> changePassword(String currentPassword, String newPassword) => 
      _remoteDataSource.changePassword(currentPassword, newPassword);
      
  Future<List<Session>> getSessions() => _remoteDataSource.getSessions();
  
  Future<void> logoutAllDevices() => _remoteDataSource.logoutAllDevices();
}
