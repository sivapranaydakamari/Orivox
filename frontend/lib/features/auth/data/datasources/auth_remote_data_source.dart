import 'package:dio/dio.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Map<String, String> _getDeviceHeaders() {
    // In a real app, use device_info_plus and package_info_plus
    return {
      'x-device-name': 'Flutter App',
      'x-platform': 'Mobile',
      'x-app-version': '1.0.0',
    };
  }

  Future<AuthResponse> login(String email, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
      options: Options(headers: _getDeviceHeaders()),
    );
    return AuthResponse.fromJson(response.data['data']);
  }

  Future<AuthResponse> register(String name, String email, String password) async {
    final response = await _dio.post(
      '/auth/register',
      data: {'name': name, 'email': email, 'password': password},
      options: Options(headers: _getDeviceHeaders()),
    );
    return AuthResponse.fromJson(response.data['data']);
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post(
      '/auth/logout',
      data: {'refreshToken': refreshToken},
    );
  }

  Future<void> resetPassword(String resetToken, String newPassword) async {
    await _dio.post(
      '/auth/reset-password',
      data: {'resetToken': resetToken, 'newPassword': newPassword},
    );
  }

  Future<UserModel> getProfile() async {
    final response = await _dio.get('/user/profile');
    return UserModel.fromJson(response.data['data']);
  }
}
