import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getMessage(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        final data = error.response!.data;
        if (data is Map<String, dynamic>) {
          if (data['message'] != null) {
            return data['message'].toString();
          }
          if (data['error'] != null) {
            return data['error'].toString();
          }
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) return 'Session expired. Please log in again.';
          if (statusCode == 403) return 'You do not have permission to perform this action.';
          if (statusCode == 404) return 'The requested resource was not found.';
          if (statusCode == 500) return 'Internal server error. Please try again later.';
          return 'Received invalid response from server ($statusCode).';
        case DioExceptionType.connectionError:
          return 'Unable to connect to the server. Please check your internet connection.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.unknown:
        default:
          return 'An unexpected error occurred.';
      }
    }
    
    if (error == null) return 'An unexpected error occurred.';
    final str = error.toString();
    if (str.contains('Exception:')) {
      return str.replaceAll('Exception:', '').trim();
    }
    if (str.contains('LateInitializationError') || str.contains('NoSuchMethodError') || str.contains('TypeError')) {
      return 'A technical error occurred. Please try refreshing the page.';
    }
    return str.isNotEmpty ? str : 'An unexpected error occurred.';
  }
}
