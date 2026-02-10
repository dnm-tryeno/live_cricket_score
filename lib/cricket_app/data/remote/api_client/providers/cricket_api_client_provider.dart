import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../cricket_api_client.dart';
import '../custom_log_interceptor.dart';
import '../../api_error_handling/error_interceptor.dart';

part 'cricket_api_client_provider.g.dart';

/// Provides a configured instance of CricketApiClient
///
/// Sets up Dio with interceptors for error handling and logging
@riverpod
CricketApiClient cricketApiClient(CricketApiClientRef ref) {
  final dio = Dio();

  // Add interceptors in order: error handling first, then logging
  dio.interceptors.addAll([
    ErrorInterceptor(), // Converts DioException to ApiException
    CustomLoggerInterceptor(), // Logs requests and responses
  ]);

  // Set default headers
  dio.options.headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  // Set timeouts (increased for slow API responses)
  // Cricket API can be slow, so we increase timeout to 60 seconds
  dio.options.connectTimeout = const Duration(seconds: 60);
  dio.options.receiveTimeout = const Duration(seconds: 60);
  dio.options.sendTimeout = const Duration(seconds: 60);

  // TODO: Replace with your actual cricket API base URL
  const baseUrl = 'https://api.cricapi.com/v1/';

  return CricketApiClient(dio, baseUrl: baseUrl);
}

/// Provider for API key (read from .env file)
@riverpod
String cricketApiKey(CricketApiKeyRef ref) {
  // Read from .env (loaded at app startup in shared_main.dart)
  final fromEnv = dotenv.env['CRICKET_API_KEY'];
  if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
  // Fallback to --dart-define if .env key is missing
  return const String.fromEnvironment('CRICKET_API_KEY', defaultValue: '');
}
