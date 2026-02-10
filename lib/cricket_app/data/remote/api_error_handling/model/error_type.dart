/// Defines different types of errors that can occur during API calls
enum ErrorType {
  /// User authentication error (401, token expired, etc.)
  notAuthenticated,

  /// Network related errors (no internet, timeout, etc.)
  networkError,

  /// Server side errors (5xx status codes)
  serverError,

  /// Client side errors (4xx status codes - validation, bad request, etc.)
  clientError,

  /// Unknown or unhandled error
  unknown,
}
