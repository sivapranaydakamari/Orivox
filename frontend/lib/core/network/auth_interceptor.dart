import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Dio _dio;
  final VoidCallback? onUnauthenticated;

  bool _isRefreshing = false;
  final _queue = <Completer<Response>>[];

  AuthInterceptor(this._storage, this._dio, {this.onUnauthenticated});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read('access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final orgId = await _storage.read('active_org_id');
    if (orgId != null) {
      options.headers['x-organization-id'] = orgId;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_isRefreshing) {
        final completer = Completer<Response>();
        _queue.add(completer);
        
        try {
          await completer.future;
          final retryOptions = err.requestOptions;
          final token = await _storage.read('access_token');
          retryOptions.headers['Authorization'] = 'Bearer $token';
          final retryResponse = await _dio.fetch(retryOptions);
          return handler.resolve(retryResponse);
        } catch (e) {
          return handler.next(err);
        }
      }

      _isRefreshing = true;
      final refreshToken = await _storage.read('refresh_token');
      if (refreshToken != null) {
        try {
          final response = await _dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
          final responseData = response.data['data'] ?? response.data;
          final newAccessToken = responseData['accessToken'];
          final newRefreshToken = responseData['refreshToken'];

          if (newAccessToken != null && newRefreshToken != null) {
            await _storage.write('access_token', newAccessToken);
            await _storage.write('refresh_token', newRefreshToken);
          }

          for (final completer in _queue) {
            completer.complete(response);
          }
          _queue.clear();

          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await _dio.fetch(err.requestOptions);
          
          _isRefreshing = false;
          return handler.resolve(retryResponse);
        } catch (e) {
          await _storage.deleteAll();
          
          for (final completer in _queue) {
            completer.completeError(e);
          }
          _queue.clear();
          
          _isRefreshing = false;
          onUnauthenticated?.call();
          return handler.next(err);
        }
      }
      
      _isRefreshing = false;
    }
    handler.next(err);
  }
}
