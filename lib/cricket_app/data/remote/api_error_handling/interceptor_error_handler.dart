import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'model/error_info.dart';
import 'exceptions/api_exceptions.dart';
import 'model/error_type.dart';

/// Handles conversion of Dio exceptions to custom API exceptions
class InterceptorErrorHandler {
  InterceptorErrorHandler._();

  /// Parses DioException and converts it to ErrorInfo
  static ErrorInfo parseErrorInfo(DioException dioException) {
    debugPrint('DioException type: ${dioException.type}');
    debugPrint('Status code: ${dioException.response?.statusCode}');
    debugPrint('Response data: ${dioException.response?.data}');

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorInfo.timeoutError();

      case DioExceptionType.connectionError:
        return ErrorInfo.networkError();

      case DioExceptionType.badResponse:
        return _parseErrorInfoFromResponse(dioException);

      case DioExceptionType.cancel:
        return ErrorInfo.unknownError('Request was cancelled.');

      case DioExceptionType.badCertificate:
        return ErrorInfo.unknownError('SSL certificate verification failed.');

      case DioExceptionType.unknown:
      default:
        // Check if it's a network error
        if (dioException.error != null &&
            dioException.error.toString().toLowerCase().contains('socket')) {
          return ErrorInfo.networkError();
        }
        return ErrorInfo.unknownError(
          dioException.message ?? 'An unknown error occurred',
        );
    }
  }

  /// Parses error info from bad response
  static ErrorInfo _parseErrorInfoFromResponse(DioException dioException) {
    final responseData = dioException.response?.data;
    final statusCode = dioException.response?.statusCode;

    // If response data is a Map, try to parse it
    if (responseData is Map<String, dynamic>) {
      return ErrorInfo.fromResponseData(responseData, statusCode);
    }

    // If response data is a String, create a generic error
    if (responseData is String) {
      return ErrorInfo(
        message: responseData,
        statusCode: statusCode,
        errorType: _getErrorTypeFromStatusCode(statusCode),
        originalMessage: responseData,
      );
    }

    // Fallback: create error based on status code only
    return ErrorInfo(
      message: 'Server error occurred.',
      statusCode: statusCode,
      errorType: _getErrorTypeFromStatusCode(statusCode),
    );
  }

  /// Determines error type based on HTTP status code
  static ErrorType _getErrorTypeFromStatusCode(int? statusCode) {
    if (statusCode == null) return ErrorType.unknown;

    if (statusCode == 401 || statusCode == 403) {
      return ErrorType.notAuthenticated;
    } else if (statusCode >= 400 && statusCode < 500) {
      return ErrorType.clientError;
    } else if (statusCode >= 500) {
      return ErrorType.serverError;
    }

    return ErrorType.unknown;
  }

  /// Converts DioException to appropriate ApiException and rejects the request
  static void rejectWithApiException(
    DioException dioException,
    ErrorInterceptorHandler handler,
  ) {
    final errorInfo = parseErrorInfo(dioException);
    final apiException = _createApiException(errorInfo);

    debugPrint('Rejecting with: ${apiException.runtimeType}');
    handler.reject(
      DioException(
        requestOptions: dioException.requestOptions,
        response: dioException.response,
        type: dioException.type,
        error: apiException,
      ),
    );
  }

  /// Creates the appropriate ApiException subclass based on error type
  static ApiException _createApiException(ErrorInfo errorInfo) {
    switch (errorInfo.errorType) {
      case ErrorType.notAuthenticated:
        return AuthenticationException(errorInfo);
      case ErrorType.networkError:
        return NetworkException(errorInfo);
      case ErrorType.serverError:
        return ServerException(errorInfo);
      case ErrorType.clientError:
        return ClientException(errorInfo);
      case ErrorType.unknown:
      default:
        return UnknownException(errorInfo);
    }
  }
}
