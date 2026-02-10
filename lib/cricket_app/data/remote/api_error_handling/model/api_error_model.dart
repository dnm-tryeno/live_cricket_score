/// Model for parsing error responses from the API
///
/// Handles various error response formats from different APIs
class ApiErrorModel {
  final String? detail;
  final String? message;
  final String? error;
  final String? msg;
  final List<dynamic>? errors; // For validation errors array

  const ApiErrorModel({
    this.detail,
    this.message,
    this.error,
    this.msg,
    this.errors,
  });

  /// Creates an ApiErrorModel from JSON response
  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      detail: json['detail'] is String ? json['detail'] as String : null,
      message: json['message'] as String?,
      error: json['error'] as String?,
      msg: json['msg'] as String?,
      errors: json['errors'] as List<dynamic>? ??
          (json['detail'] is List ? json['detail'] as List<dynamic> : null),
    );
  }

  /// Gets a single error message from various possible error fields
  String get singleErrorMessage {
    if (detail != null && detail!.isNotEmpty) return detail!;
    if (message != null && message!.isNotEmpty) return message!;
    if (error != null && error!.isNotEmpty) return error!;
    if (msg != null && msg!.isNotEmpty) return msg!;
    if (errors != null && errors!.isNotEmpty) {
      // Join multiple error messages
      return errors!.map((e) => e.toString()).join(', ');
    }
    return 'Unknown error occurred';
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'message': message,
      'error': error,
      'msg': msg,
      'errors': errors,
    };
  }
}
