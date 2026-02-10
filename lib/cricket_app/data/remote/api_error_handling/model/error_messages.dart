/// Centralized error messages for API errors
class ErrorMessages {
  ErrorMessages._();

  /// Network connection error message
  static const String networkError =
      'No internet connection. Please check your network and try again.';

  /// Request timeout error message
  static const String timeoutError =
      'Request timeout. Please check your connection and try again.';

  /// Server error message (5xx)
  static const String serverError =
      'Server is temporarily unavailable. Please try again later.';

  /// Authentication error message (401)
  static const String authError =
      'Authentication failed. Please log in again to continue.';

  /// Client error message (4xx)
  static const String clientError =
      'Invalid request. Please check your input and try again.';

  /// Scorecard not found (CricAPI: scorecard not available for this match)
  static const String scorecardNotFound =
      'Scorecard is not available for this match yet.';

  /// Unknown error message
  static const String unknownError =
      'Something went wrong. Please try again.';

  /// Data parsing error
  static const String parsingError =
      'Failed to process response. Please try again.';
}
