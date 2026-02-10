import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Firebase Remote Config Service
/// Handles remote configuration for ad control and feature flags
class FirebaseRemoteConfigService {
  static FirebaseRemoteConfig? _remoteConfig;
  static bool _isInitialized = false;

  // Default values - ad toggles + iOS ad unit IDs (control from Firebase, change anytime)
  static const String _defaultIosBanner =
      '/229445249,22493636089/highR_RS88_Crictvlivecricketscore_488_BANNER_16326_090226';
  static const String _defaultIosAppOpen =
      '/229445249,22493636089/highR_RS88_Crictvlivecricketscore_488_APP_OPEN_16325_090226';
  static const String _defaultIosInterstitial =
      '/229445249,22493636089/highR_RS88_Crictvlivecricketscore_488_INTERSTITIAL_16327_090226';
  static const String _defaultIosNative =
      '/229445249,22493636089/highR_RS88_Crictvlivecricketscore_488_NATIVE_16328_090226';

  static const Map<String, dynamic> _defaults = {
    'ads_enabled_android': true,
    'ads_enabled_ios': true,
    'ios_ad_unit_banner': _defaultIosBanner,
    'ios_ad_unit_app_open': _defaultIosAppOpen,
    'ios_ad_unit_interstitial': _defaultIosInterstitial,
    'ios_ad_unit_native': _defaultIosNative,
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
        debugPrint('📱 ===== iOS Ad Unit IDs (from Firebase Remote Config) =====');
        debugPrint('📱 iOS Banner     : $iosAdUnitBanner');
        debugPrint('📱 iOS App Open   : $iosAdUnitAppOpen');
        debugPrint('📱 iOS Interstitial: $iosAdUnitInterstitial');
        debugPrint('📱 iOS Native     : $iosAdUnitNative');
        debugPrint('📱 ========================================================');
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

  /// iOS only: Banner ad unit ID from Remote Config (change in Firebase = no app update)
  static String get iosAdUnitBanner {
    try {
      final v = _remoteConfig?.getString('ios_ad_unit_banner');
      return (v != null && v.isNotEmpty) ? v : _defaultIosBanner;
    } catch (e) {
      return _defaultIosBanner;
    }
  }

  /// iOS only: App Open ad unit ID from Remote Config
  static String get iosAdUnitAppOpen {
    try {
      final v = _remoteConfig?.getString('ios_ad_unit_app_open');
      return (v != null && v.isNotEmpty) ? v : _defaultIosAppOpen;
    } catch (e) {
      return _defaultIosAppOpen;
    }
  }

  /// iOS only: Interstitial ad unit ID from Remote Config
  static String get iosAdUnitInterstitial {
    try {
      final v = _remoteConfig?.getString('ios_ad_unit_interstitial');
      return (v != null && v.isNotEmpty) ? v : _defaultIosInterstitial;
    } catch (e) {
      return _defaultIosInterstitial;
    }
  }

  /// iOS only: Native ad unit ID from Remote Config
  static String get iosAdUnitNative {
    try {
      final v = _remoteConfig?.getString('ios_ad_unit_native');
      return (v != null && v.isNotEmpty) ? v : _defaultIosNative;
    } catch (e) {
      return _defaultIosNative;
    }
  }

  /// Get remote config instance
  static FirebaseRemoteConfig? get remoteConfig => _remoteConfig;
}
