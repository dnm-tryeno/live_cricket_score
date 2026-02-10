import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptor_error_handler.dart';

/// Interceptor that handles errors from API calls
///
/// Converts DioException to custom ApiException with detailed error information
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔴 API ERROR');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('URL: ${err.requestOptions.uri}');
    debugPrint('Method: ${err.requestOptions.method}');
    debugPrint('Status Code: ${err.response?.statusCode}');
    debugPrint('Error Type: ${err.type}');
    debugPrint('Response Error: ${err.response?.data}');
    debugPrint('Error Message: ${err.message}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // Convert DioException to ApiException
    InterceptorErrorHandler.rejectWithApiException(err, handler);
  }
}
