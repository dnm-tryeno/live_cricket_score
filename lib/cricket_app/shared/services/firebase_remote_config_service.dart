import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Firebase Remote Config Service
/// Handles remote configuration for ad control and feature flags
class FirebaseRemoteConfigService {
  static FirebaseRemoteConfig? _remoteConfig;
  static bool _isInitialized = false;

  // iOS ad unit IDs: sirf Firebase Remote Config se aayengi, Dart mein hardcoded nahi
  // Firebase Console mein set karo: ios_ad_unit_banner, ios_ad_unit_app_open,
  // ios_ad_unit_interstitial, ios_ad_unit_native
  static const Map<String, dynamic> _defaults = {
    'ads_enabled_android': true,
    'ads_enabled_ios': true,
    'ios_ad_unit_banner': '',
    'ios_ad_unit_app_open': '',
    'ios_ad_unit_interstitial': '',
    'ios_ad_unit_native': '',
  };

  /// Initialize Firebase Remote Config
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Set config settings
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // Set default values
      await _remoteConfig!.setDefaults(_defaults);

      // Fetch and activate
      await _remoteConfig!.fetchAndActivate();

      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('✅ Firebase Remote Config initialized');
        debugPrint(
          '📱 ===== iOS Ad Unit IDs (from Firebase Remote Config) =====',
        );
        debugPrint('📱 iOS Banner     : $iosAdUnitBanner');
        debugPrint('📱 iOS App Open   : $iosAdUnitAppOpen');
        debugPrint('📱 iOS Interstitial: $iosAdUnitInterstitial');
        debugPrint('📱 iOS Native     : $iosAdUnitNative');
        debugPrint(
          '📱 ========================================================',
        );
        // iOS App ID: Info.plist se read karo (Remote Config se nahi)
        if (Platform.isIOS) {
          await _printIosAppId();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error initializing Remote Config: $e');
      }
      _isInitialized = false;
    }
  }

  /// Fetch latest config from server
  static Future<void> fetchAndActivate() async {
    try {
      if (_remoteConfig != null) {
        await _remoteConfig!.fetchAndActivate();
        if (kDebugMode) {
          debugPrint('✅ Remote Config fetched and activated');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching Remote Config: $e');
      }
    }
  }

  /// Check if Android ads are enabled
  static bool get androidAdsEnabled {
    try {
      return _remoteConfig?.getBool('ads_enabled_android') ??
          _defaults['ads_enabled_android'] as bool;
    } catch (e) {
      return _defaults['ads_enabled_android'] as bool;
    }
  }

  /// Check if iOS ads are enabled
  static bool get iosAdsEnabled {
    try {
      return _remoteConfig?.getBool('ads_enabled_ios') ??
          _defaults['ads_enabled_ios'] as bool;
    } catch (e) {
      return _defaults['ads_enabled_ios'] as bool;
    }
  }

  /// iOS only: Banner ad unit ID — sirf Firebase Remote Config se
  static String get iosAdUnitBanner {
    try {
      return _remoteConfig?.getString('ios_ad_unit_banner') ?? '';
    } catch (e) {
      return '';
    }
  }

  /// iOS only: App Open ad unit ID — sirf Firebase Remote Config se
  static String get iosAdUnitAppOpen {
    try {
      return _remoteConfig?.getString('ios_ad_unit_app_open') ?? '';
    } catch (e) {
      return '';
    }
  }

  /// iOS only: Interstitial ad unit ID — sirf Firebase Remote Config se
  static String get iosAdUnitInterstitial {
    try {
      return _remoteConfig?.getString('ios_ad_unit_interstitial') ?? '';
    } catch (e) {
      return '';
    }
  }

  /// iOS only: Native ad unit ID — sirf Firebase Remote Config se
  static String get iosAdUnitNative {
    try {
      return _remoteConfig?.getString('ios_ad_unit_native') ?? '';
    } catch (e) {
      return '';
    }
  }

  /// Get remote config instance
  static FirebaseRemoteConfig? get remoteConfig => _remoteConfig;

  /// iOS only: Info.plist se GADApplicationIdentifier read karke print karo
  static Future<void> _printIosAppId() async {
    try {
      const channel = MethodChannel('com.app.ios_info');
      final appId = await channel.invokeMethod<String>('getGADAppId');
      debugPrint(
        '📱 iOS App ID (Info.plist → GADApplicationIdentifier): $appId',
      );
    } catch (e) {
      debugPrint('⚠️ iOS App ID read error: $e');
    }
  }
}
