import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Custom logger interceptor for API requests and responses
///
/// Logs request details and automatically adds authentication token
class CustomLoggerInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions request,
    RequestInterceptorHandler handler,
  ) async {
    // Get authentication token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Add Bearer token to Authorization header if available
    _addTokenToHeaders(request.headers, token);

    // Log request details
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🌐 API REQUEST');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('URL: ${request.baseUrl}${request.path}');
    debugPrint('METHOD: ${request.method}');
    debugPrint('HEADERS: ${request.headers}');

    if (request.queryParameters.isNotEmpty) {
      debugPrint('QUERY PARAMS: ${request.queryParameters}');
    }

    if (request.data != null) {
      if (request.data is FormData) {
        final formData = request.data as FormData;
        debugPrint('REQUEST BODY (FormData):');
        for (final field in formData.fields) {
          debugPrint('  ${field.key}: ${field.value}');
        }
        for (final file in formData.files) {
          debugPrint('  ${file.key}: ${file.value.filename}');
        }
      } else {
        try {
          final jsonString = jsonEncode(request.data);
          debugPrint('REQUEST BODY: $jsonString');
        } catch (e) {
          debugPrint('REQUEST BODY: ${request.data}');
        }
      }
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    handler.next(request);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('✅ API RESPONSE');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('URL: ${response.requestOptions.uri}');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('STATUS MESSAGE: ${response.statusMessage}');

    if (response.data != null) {
      try {
        final jsonString = jsonEncode(response.data);
        debugPrint('RESPONSE BODY: $jsonString');
      } catch (e) {
        debugPrint('RESPONSE BODY: ${response.data}');
      }
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    handler.next(response);
  }

  /// Adds authentication token to request headers
  void _addTokenToHeaders(Map<String, dynamic> headers, String? token) {
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      headers.remove('Authorization');
    }
  }
}
