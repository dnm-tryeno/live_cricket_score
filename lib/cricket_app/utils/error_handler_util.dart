import 'package:flutter/material.dart';
import '../data/remote/api_error_handling/exceptions/api_exceptions.dart';

/// Utility class for handling API errors in the UI
class ErrorHandlerUtil {
  ErrorHandlerUtil._();

  /// Shows an error dialog based on the exception type
  static void showErrorDialog(
    BuildContext context,
    Object error, {
    VoidCallback? onRetry,
  }) {
    String message = 'An unexpected error occurred';

    if (error is ApiException) {
      message = error.message;
    } else {
      message = error.toString();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows a snackbar with error message (toast-like)
  static void showErrorSnackBar(BuildContext context, Object error) {
    String message = 'An unexpected error occurred';

    if (error is ApiException) {
      message = error.message;
    } else {
      message = error.toString();
    }

    // Hide any existing snackbar first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Gets a user-friendly error message from an exception
  static String getErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'An unexpected error occurred';
  }
}
