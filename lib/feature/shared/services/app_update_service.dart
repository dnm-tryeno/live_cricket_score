import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_project/feature/shared/navigation/global_keys.dart';

class AppUpdateService {
  static bool _hasShownDialog = false;

  /// Check for app updates and show dialog if update is available
  static Future<void> checkForUpdate(BuildContext? context) async {
    if (_hasShownDialog) {
      return;
    }

    try {

      // For iOS, use bundle identifier; new_version_plus will handle it
      // Note: For production, you may need the actual App Store numeric ID
      final newVersion = NewVersionPlus(
        androidId: 'com.aryatech.cricketlivescore',
        iOSId: 'com.aryatech.cricketlivescore', // Bundle identifier
      );

      VersionStatus finalStatus;
      try {
        final fetchedStatus = await newVersion.getVersionStatus();

        debugPrint(
          '📱 Update check - Platform: ${Platform.isIOS ? "iOS" : "Android"}',
        );
        debugPrint(
          '📱 Fetched status: ${fetchedStatus != null ? "Found" : "Null"}',
        );

        if (fetchedStatus != null) {
          debugPrint('📱 Can update: ${fetchedStatus.canUpdate}');
          debugPrint('📱 Local version: ${fetchedStatus.localVersion}');
          debugPrint('📱 Store version: ${fetchedStatus.storeVersion}');
        }

        if (fetchedStatus == null || !fetchedStatus.canUpdate) {
          debugPrint('📱 No update available or cannot update');
          return;
        }

        finalStatus = fetchedStatus;
      } catch (e) {
        debugPrint('⚠️ Error fetching version status: $e');
        return;
      }

      BuildContext? dialogContext = context;

      if (dialogContext == null || !dialogContext.mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        dialogContext =
            context ?? scaffoldMessengerKeySingleton?.currentContext;
      }

      if (dialogContext != null && dialogContext.mounted) {
        // Wait a bit more if Navigator is not ready
        if (Navigator.maybeOf(dialogContext) == null) {
          await Future.delayed(const Duration(milliseconds: 500));
        }

        if (dialogContext.mounted && Navigator.maybeOf(dialogContext) != null) {
          _showUpdateDialog(dialogContext, finalStatus);
          _hasShownDialog = true;
        } else {
          debugPrint('⚠️ Cannot show update dialog - Navigator not available');
        }
      } else {
        debugPrint('⚠️ Cannot show update dialog - context not available');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error checking for app update: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Show update dialog to user
  static void _showUpdateDialog(BuildContext context, VersionStatus status) {
    if (!context.mounted) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.7),
        builder: (BuildContext dialogContext) {
          return PopScope(
            canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color(0xFF1F2937),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update Available',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Do you want to update?\n\nA new version (${status.storeVersion}) is available${Platform.isIOS
                          ? ' on App Store'
                          : ' on Play Store'}.\n\nCurrent version: ${status.localVersion}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                _launchStore(status);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Error showing update dialog: $e');
    }
  }

  /// Launch Play Store or App Store to update the app
  static Future<void> _launchStore(VersionStatus status) async {
    try {
      if (Platform.isIOS) {
        // For iOS, try App Store link first
        final uri = Uri.parse(status.appStoreLink);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback: try to open App Store with bundle ID
          final appStoreUri = Uri.parse(
            'https://apps.apple.com/app/id6739782344', // Replace with actual App Store ID
          );
          await launchUrl(appStoreUri, mode: LaunchMode.externalApplication);
        }
      } else {
        // For Android
        final uri = Uri.parse(status.appStoreLink);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback: try market:// protocol
          final playStoreUri = Uri.parse(
            'market://details?id=com.aryatech.cricketlivescore',
          );
          await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      debugPrint('Error launching store: $e');
    }
  }
}
