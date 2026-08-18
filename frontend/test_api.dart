import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

void main() async {
  try {
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api/v1'));
    final response = await dio.get('/health');
    debugPrint(response.data.toString());
    debugPrint('SUCCESS');
  } catch (e) {
    debugPrint('ERROR: $e');
  }
}
