/// Application constants for better maintainability and code quality
class AppConstants {
  // User IDs - TODO: Replace with dynamic user management
  static const String defaultCurrentUserId = 'dnm.dpm@gmail.com';
  static const String adminUserId = 'shippers@gmail.com';

  // Hardcoded users for chat functionality
  static const List<String> hardcodedUsers = [
    'hanniy36@gmail.com',
    'dinkar1708@gmail.com',
    'alex.gorban@del-qui.com',
    'tryeno.work@gmail.com',
  ];

  // UI Constants
  static const double defaultBorderRadius = 15.0;
  static const double defaultPadding = 16.0;
  static const double defaultSpacing = 8.0;

  // Time Constants
  static const int messageRefreshDelayMs = 500;
  static const int eventDurationLimitDays = 99;

  // Fixed DateTime Values
  static const int fixedSecond = 11;
  static const int fixedMillisecond = 337;

  // Error Messages
  static const String genericErrorMessage = 'An unexpected error occurred.';
  static const String networkErrorMessage = 'Network error occurred.';
  static const String chatCreationErrorMessage = 'Failed to create chat.';
  static const String imageUploadErrorMessage = 'Failed to upload image.';

  // Success Messages
  static const String chatCreatedMessage = 'Chat created successfully.';
  static const String userAddedMessage = 'User added to chat successfully.';
  static const String imageUploadedMessage = 'Image uploaded successfully.';

  static const String methodChannelName =
      'com.fluter.template.delqui/environment';
  static const String methodChannelMethodName = 'setEnvironmentKey';
  static const String methodChannelKeyName = 'keyName';
  static const String methodChannelValueName = 'value';

  // Environment key constants
  static const String methodChannelEnvironmentKeyMapsApiKey = 'mapsApiKey';

  // Font Family Constants
  static const String fontFamilyInter = 'Inter';
  static const String fontFamilySFPro = 'SF Pro';

  // File Extension Constants
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
    'svg',
  ];

  static const List<String> allowedDocumentExtensions = [
    'pdf',
    'doc',
    'docx',
    'txt',
    'rtf',
  ];

  static const List<String> allowedFileExtensions = [
    ...allowedImageExtensions,
    ...allowedDocumentExtensions,
  ];

  // Main allowed extensions list (alias for allowedFileExtensions)
  static const List<String> allowedExtensions = allowedFileExtensions;

  // File Type Check Methods
  static bool isImageFile(String fileName) {
    if (fileName.isEmpty) return false;
    
    final extension = fileName.split('.').last.toLowerCase();
    return allowedImageExtensions.contains(extension);
  }

  // Shorter alias for isImageFile
  static bool isImage(String fileName) => isImageFile(fileName);

  static bool isDocumentFile(String fileName) {
    if (fileName.isEmpty) return false;
    
    final extension = fileName.split('.').last.toLowerCase();
    return allowedDocumentExtensions.contains(extension);
  }

  static bool isAllowedFile(String fileName) {
    if (fileName.isEmpty) return false;
    
    final extension = fileName.split('.').last.toLowerCase();
    return allowedFileExtensions.contains(extension);
  }
}
