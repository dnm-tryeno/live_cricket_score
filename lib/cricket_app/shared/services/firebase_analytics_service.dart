import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Analytics Service
/// Handles app analytics tracking for both iOS and Android
class FirebaseAnalyticsService {
  static FirebaseAnalytics? _analytics;
  static FirebaseAnalyticsObserver? _observer;

  /// Initialize Firebase Analytics (iOS and Android).
  /// Logs app open event whenever app is launched.
  static Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);

      // Log app open whenever app is opened (at launch)
      await logAppOpen();

      if (kDebugMode) {
        print(
          '✅ Firebase Analytics initialized for ${Platform.isIOS ? "iOS" : "Android"}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing Firebase Analytics: $e');
      }
    }
  }

  /// Log app open event
  static Future<void> logAppOpen() async {
    if (_analytics == null) {
      return;
    }

    try {
      await _analytics?.logAppOpen();
      if (kDebugMode) {
        print('📊 Logged app open event');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error logging app open: $e');
      }
    }
  }

  /// Get analytics observer for navigation
  static FirebaseAnalyticsObserver? get observer => _observer;

  /// Get analytics instance
  static FirebaseAnalytics? get analytics => _analytics;
}
