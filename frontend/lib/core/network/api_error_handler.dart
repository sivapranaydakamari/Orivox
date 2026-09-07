import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getMessage(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        final data = error.response!.data;
        if (data is Map<String, dynamic>) {
          if (data['error'] is Map<String, dynamic>) {
            final errorObj = data['error'] as Map<String, dynamic>;
            final code = errorObj['code']?.toString();
            final message = errorObj['message']?.toString();

            if (code != null) {
              final mappedMessage = _mapErrorCode(code);
              if (mappedMessage != null) return mappedMessage;
            }
            if (message != null && message.isNotEmpty) {
              return message;
            }
          } else if (data['error'] != null) {
            return data['error'].toString();
          } else if (data['message'] != null) {
            return data['message'].toString();
          }
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'The request took too long. Please try again.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) return 'Session expired. Please log in again.';
          if (statusCode == 403) return 'You don\'t have permission to perform this action.';
          if (statusCode == 404) return 'The requested resource could not be found.';
          if (statusCode == 500) return 'Something went wrong on the server. Please try again.';
          return 'Received invalid response from server ($statusCode).';
        case DioExceptionType.connectionError:
          return 'Unable to connect to Orivox. Check your internet connection and try again.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.unknown:
        default:
          return 'Something went wrong. Please try again.';
      }
    }
    
    if (error is String && error.isNotEmpty) {
      return error;
    }

    // Fallback for non-Dio errors - do not expose raw exceptions to the user
    return 'Something went wrong. Please try again.';
  }

  static String? _mapErrorCode(String code) {
    switch (code) {
      case 'GITHUB_CONTENT_ACCESS_DENIED':
        return 'Orivox cannot access this repository\'s contents. Please ensure the GitHub App has Contents (read-only) permission in GitHub settings.';
      case 'GITHUB_REPOSITORY_FETCH_FAILED':
        return 'Unable to load your GitHub repositories. Please try again.';
      case 'GITHUB_INSTALLATION_NOT_FOUND':
        return 'No GitHub connection was found. Please connect GitHub first.';
      case 'GITHUB_NO_REPOSITORIES':
        return 'No repositories are available for this GitHub App installation.';
      case 'GITHUB_UNAUTHORIZED':
        return 'You don\'t have permission to access GitHub repositories.';
      case 'GITHUB_RATE_LIMITED':
        return 'GitHub API rate limit reached. Please wait a moment and try again.';
      case 'REPOSITORY_ALREADY_CONNECTED':
        return 'This repository is already connected to this project.';
      case 'PROJECT_ACCESS_DENIED':
        return 'You don\'t have access to this project.';
      case 'ORGANIZATION_ACCESS_DENIED':
        return 'You don\'t have access to this organization.';
      case 'DOCUMENT_PROCESSING_FAILED':
        return 'Document extraction could not be completed. Please verify the document format.';
      default:
        return null;
    }
  }
}
