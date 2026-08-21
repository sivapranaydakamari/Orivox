import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/env.dart';
import 'auth_interceptor.dart';
import '../storage/secure_storage.dart';

import 'dart:async';

final unauthenticatedEventStream = StreamController<void>.broadcast();

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final dio = Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
  ));

  dio.interceptors.addAll([
    AuthInterceptor(
      storage, 
      dio,
      onUnauthenticated: () {
        unauthenticatedEventStream.add(null);
      }
    ),
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  ]);

  return dio;
});
