import 'package:flutter/foundation.dart';
import 'error_type.dart';
import 'error_messages.dart';
import 'api_error_model.dart';

/// Contains detailed information about an API error
class ErrorInfo {
  final String message;
  final int? statusCode;
  final ErrorType errorType;
  final String? originalMessage;
  final Map<String, dynamic>? responseData;

  const ErrorInfo({
    required this.message,
    required this.errorType,
    this.statusCode,
    this.originalMessage,
    this.responseData,
  });

  /// Creates ErrorInfo from API response data
  factory ErrorInfo.fromResponseData(
    Map<String, dynamic> responseData,
    int? statusCode,
  ) {
    try {
      // Parse the error model from response
      final apiErrorModel = ApiErrorModel.fromJson(responseData);
      final errorMessage = apiErrorModel.singleErrorMessage.toLowerCase();

      // Pattern matching to determine error type
      final errorPatterns = [
        {
          'pattern': RegExp(
            r'not authenticated|unauthorized|token|auth|authentication|login',
            caseSensitive: false,
          ),
          'type': ErrorType.notAuthenticated,
          'message': ErrorMessages.authError,
        },
        {
          'pattern': RegExp(
            r'validation|invalid|required|missing|bad request',
            caseSensitive: false,
          ),
          'type': ErrorType.clientError,
          'message': ErrorMessages.clientError,
        },
        {
          'pattern': RegExp(
            r'scorecard.*not found|not found.*scorecard',
            caseSensitive: false,
          ),
          'type': ErrorType.clientError,
          'message': ErrorMessages.scorecardNotFound,
        },
        {
          'pattern': RegExp(
            r'server error|internal|service unavailable|maintenance',
            caseSensitive: false,
          ),
          'type': ErrorType.serverError,
          'message': ErrorMessages.serverError,
        },
        {
          'pattern': RegExp(
            r'network|connection|timeout|execution timeout expired|timeout period elapsed|server is not responding',
            caseSensitive: false,
          ),
          'type': ErrorType.networkError,
          'message': ErrorMessages.networkError,
        },
      ];

      // Try to match error message against patterns
      for (final pattern in errorPatterns) {
        if ((pattern['pattern'] as RegExp).hasMatch(errorMessage)) {
          return ErrorInfo(
            message: pattern['message'] as String,
            statusCode: statusCode,
            errorType: pattern['type'] as ErrorType,
            originalMessage: apiErrorModel.singleErrorMessage,
            responseData: responseData,
          );
        }
      }

      // If no pattern matched, determine by status code
      return ErrorInfo._fromStatusCode(
        statusCode,
        apiErrorModel.singleErrorMessage,
        responseData,
      );
    } catch (e) {
      debugPrint('Error parsing error info: $e');
      return ErrorInfo.unknownError('Failed to parse error response');
    }
  }

  /// Creates ErrorInfo based on HTTP status code
  factory ErrorInfo._fromStatusCode(
    int? statusCode,
    String originalMessage,
    Map<String, dynamic>? responseData,
  ) {
    if (statusCode == null) {
      return ErrorInfo.unknownError(originalMessage);
    }

    if (statusCode == 401 || statusCode == 403) {
      return ErrorInfo(
        message: ErrorMessages.authError,
        statusCode: statusCode,
        errorType: ErrorType.notAuthenticated,
        originalMessage: originalMessage,
        responseData: responseData,
      );
    } else if (statusCode >= 400 && statusCode < 500) {
      return ErrorInfo(
        message: ErrorMessages.clientError,
        statusCode: statusCode,
        errorType: ErrorType.clientError,
        originalMessage: originalMessage,
        responseData: responseData,
      );
    } else if (statusCode >= 500) {
      return ErrorInfo(
        message: ErrorMessages.serverError,
        statusCode: statusCode,
        errorType: ErrorType.serverError,
        originalMessage: originalMessage,
        responseData: responseData,
      );
    }

    return ErrorInfo.unknownError(originalMessage);
  }

  /// Creates a network error
  factory ErrorInfo.networkError() {
    return const ErrorInfo(
      message: ErrorMessages.networkError,
      errorType: ErrorType.networkError,
    );
  }

  /// Creates a timeout error
  factory ErrorInfo.timeoutError() {
    return const ErrorInfo(
      message: ErrorMessages.timeoutError,
      errorType: ErrorType.networkError,
    );
  }

  /// Creates an unknown error
  factory ErrorInfo.unknownError([String? customMessage]) {
    return ErrorInfo(
      message: customMessage ?? ErrorMessages.unknownError,
      errorType: ErrorType.unknown,
      originalMessage: customMessage,
    );
  }

  /// Creates a parsing error
  factory ErrorInfo.parsingError() {
    return const ErrorInfo(
      message: ErrorMessages.parsingError,
      errorType: ErrorType.unknown,
    );
  }

  @override
  String toString() {
    return 'ErrorInfo(message: $message, statusCode: $statusCode, type: $errorType)';
  }
}
