import '../model/error_info.dart';
import '../model/error_type.dart';

/// Base exception class for all API errors
class ApiException implements Exception {
  final ErrorInfo errorInfo;

  const ApiException(this.errorInfo);

  String get message => errorInfo.message;
  ErrorType get errorType => errorInfo.errorType;
  int? get statusCode => errorInfo.statusCode;
  String? get originalMessage => errorInfo.originalMessage;

  @override
  String toString() {
    return 'ApiException: ${errorInfo.toString()}';
  }
}

/// Authentication related errors (401, 403)
class AuthenticationException extends ApiException {
  const AuthenticationException(super.errorInfo);

  @override
  String toString() {
    return 'AuthenticationException: ${errorInfo.message}';
  }
}

/// Network related errors (no internet, timeout)
class NetworkException extends ApiException {
  const NetworkException(super.errorInfo);

  @override
  String toString() {
    return 'NetworkException: ${errorInfo.message}';
  }
}

/// Server errors (5xx status codes)
class ServerException extends ApiException {
  const ServerException(super.errorInfo);

  @override
  String toString() {
    return 'ServerException: ${errorInfo.message}';
  }
}

/// Client errors (4xx status codes - validation, bad request)
class ClientException extends ApiException {
  const ClientException(super.errorInfo);

  @override
  String toString() {
    return 'ClientException: ${errorInfo.message}';
  }
}

/// Unknown or unhandled errors
class UnknownException extends ApiException {
  const UnknownException(super.errorInfo);

  @override
  String toString() {
    return 'UnknownException: ${errorInfo.message}';
  }
}
