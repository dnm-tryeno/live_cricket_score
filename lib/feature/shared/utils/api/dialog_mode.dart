/// Dialog modes for authentication error dialogs
enum DialogMode { retry, forceRetry, retryLogin, exit, notice }

/// Extension to get string representation of dialog mode
extension DialogModeExtension on DialogMode {
  /// Get the enum value as string
  String get value {
    switch (this) {
      case DialogMode.retry:
        return 'retry';
      case DialogMode.forceRetry:
        return 'forceRetry';
      case DialogMode.retryLogin:
        return 'retryLogin';
      case DialogMode.exit:
        return 'exit';
      case DialogMode.notice:
        return 'notice';
    }
  }

  /// Get user-friendly button text for the dialog mode
  String get buttonText {
    switch (this) {
      case DialogMode.retry:
        return 'Retry';
      case DialogMode.forceRetry:
        return 'Retry';
      case DialogMode.retryLogin:
        return 'Retry Login';
      case DialogMode.exit:
        return 'Exit App';
      case DialogMode.notice:
        return 'OK';
    }
  }

  /// Get user-friendly dialog title for the dialog mode
  String get dialogTitle {
    switch (this) {
      case DialogMode.retry:
        return 'Error';
      case DialogMode.forceRetry:
        return 'Error occurred';
      case DialogMode.retryLogin:
        return 'Authentication Error';
      case DialogMode.exit:
        return 'Fatal Error';
      case DialogMode.notice:
        return 'Information';
    }
  }

  /// Get secondary button text (like Cancel) for the dialog mode
  String? get secondaryButtonText {
    switch (this) {
      case DialogMode.retry:
        return 'Cancel';
      case DialogMode.forceRetry:
        return null; // No secondary button for force retry
      case DialogMode.retryLogin:
        return null; // No secondary button for retry login
      case DialogMode.exit:
        return null; // No secondary button for exit
      case DialogMode.notice:
        return 'Cancel';
    }
  }

  /// Check if the dialog mode should show a secondary button
  bool get hasSecondaryButton {
    return secondaryButtonText != null;
  }

  /// Check if the dialog mode is destructive (like exit)
  bool get isDestructive {
    switch (this) {
      case DialogMode.exit:
        return true;
      default:
        return false;
    }
  }
}
