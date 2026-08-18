import 'package:dio/dio.dart';
import '../../../../features/auth/data/models/user_model.dart';
import '../../../../features/auth/domain/entities/user.dart';
import '../../domain/entities/profile_models.dart';

class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  Future<User> getProfile() async {
    final response = await _dio.get('/user/profile');
    return UserModel.fromJson(response.data['data']).toEntity();
  }

  Future<User> updateProfile(String name) async {
    final response = await _dio.put('/user/profile', data: {'name': name});
    return UserModel.fromJson(response.data['data']).toEntity();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _dio.post('/user/change-password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  Future<List<Session>> getSessions() async {
    final response = await _dio.get('/auth/sessions');
    return (response.data['data'] as List)
        .map((e) => Session.fromJson(e))
        .toList();
  }

  Future<void> logoutAllDevices() async {
    await _dio.post('/auth/sessions/logout-all');
  }
}
