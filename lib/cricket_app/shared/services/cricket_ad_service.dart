import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../constants/cricket_ad_constants.dart';
import 'firebase_remote_config_service.dart';
import '../../../feature/shared/services/admob_service.dart';

/// Cricket App Ad Service
/// Handles ads with Firebase Remote Config control for both iOS (AdX) and Android (AdMob)
///
/// Firebase Remote Config Parameters (required in Firebase Console):
/// - ads_enabled (Boolean): Master switch - must be true for any ads to show
/// - android_admob_enabled (Boolean): Android AdMob control
/// - ios_adex_enabled (Boolean): iOS AdX control
/// - banner_ads_enabled (Boolean): Banner ads control
/// - interstitial_ads_enabled (Boolean): Interstitial ads control
/// - rewarded_ads_enabled (Boolean): Rewarded ads control
/// - ad_frequency (Number): Ad frequency (screens between ads)
///
/// All ad types check Firebase Remote Config before showing/loading.
/// If ads_enabled=false, NO ads will show (both platforms).
class CricketAdService {
  static BannerAd? _bannerAd;
  static int _screenViewCount = 0;

  // App-open ad: preloads at app start, shows when app comes to foreground (resumed)
  // Android: Direct AdMob (no Firebase needed)
  // iOS: AdEx + Remote Config (to be implemented later)
  static AppOpenAd? _appOpenAd;
  static bool _isAppOpenAdReady = false;
  static bool _isShowingAppOpenAd = false;
  static bool _isFirstLaunch = true; // Track first launch to auto-show ad
  static bool _shouldShowOnLoad =
      false; // Flag to auto-show when ad loads (for foreground)
  static DateTime? _lastAdShownTime; // Prevent rapid back-to-back ads
  static int _appOpenAdLoadAttempts = 0;
  static const int _maxAppOpenAdLoadAttempts = 3;
  static const Duration _minTimeBetweenAds = Duration(
    seconds: 10,
  ); // Prevent immediate re-show (just after close)

  // Interstitial ad
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdReady = false;
  static bool _isLoadingInterstitial = false;

  /// Initialize ads
  static Future<void> initialize() async {
    try {
      // Reset flags on each app start (for cold start detection)
      _isFirstLaunch = true;
      _isShowingAppOpenAd = false;
      _shouldShowOnLoad = false;
      _lastAdShownTime = null;

      // Initialize Mobile Ads SDK first (required for both platforms)
      await MobileAds.instance.initialize();

      // Configure test devices for Android (if in debug mode)
      if (kDebugMode && Platform.isAndroid) {
        AdMobService.configureTestDevices();
      }

      // For iOS: Configure test mode for Firebase AdEx
      if (kDebugMode && Platform.isIOS) {
        // iOS automatically uses test ads when using test ad unit IDs
        // No additional configuration needed for Firebase AdEx test mode
        debugPrint(
          '📱 iOS Firebase AdEx Test Mode: Enabled (using test ad unit IDs)',
        );
        debugPrint(
          '⚠️ IMPORTANT: iOS App Open Ads may NOT display on simulator',
        );
        debugPrint('⚠️ Please test on REAL iOS device for proper ad display');
      }

      // Load app-open ad at app start (both platforms when allowed)
      final canShowAppOpen = shouldShowAds();
      debugPrint('✅ Cricket Ad Service initialized');
      debugPrint('📱 Platform: ${Platform.isIOS ? "iOS" : "Android"}');
      debugPrint('📢 App-open ad allowed: $canShowAppOpen');
      debugPrint('📢 First launch flag reset: $_isFirstLaunch');
      if (canShowAppOpen) {
        loadAppOpenAd();
      }
    } catch (e) {
      debugPrint('❌ Error initializing Cricket Ad Service: $e');
    }
  }

  /// Check if ads should be shown (common check for all ad types)
  /// Android: Check ads_enabled_android
  /// iOS: Check ads_enabled_ios
  static bool shouldShowAds() {
    bool enabled = false;
    try {
      if (Platform.isAndroid) {
        // client always want to show ads on android
        return true;
      } else {
        enabled = FirebaseRemoteConfigService.iosAdsEnabled;
      }
    } catch (e) {
      debugPrint('⚠️ Error checking shouldShowAds: $e');
    }
    debugPrint(
      '📢 shouldShowAds: $enabled (${Platform.isAndroid ? "Android" : "iOS"})',
    );
    return enabled;
  }

  /// Increment screen view count for ad frequency control
  static void incrementScreenView() {
    _screenViewCount++;
  }

  /// Check if ad should be shown based on frequency
  /// Default frequency: 3 screens (for both platforms)
  static bool shouldShowAdByFrequency() {
    const int frequency = 3; // Show ad after every 3 screens
    return _screenViewCount % frequency == 0;
  }

  /// Get banner ad widget
  static Widget getBannerAdWidget({double? padding}) {
    if (!shouldShowAds()) {
      return const SizedBox.shrink();
    }

    return BannerAdWidget(padding: padding, adUnitId: _getBannerAdUnitId());
  }

  /// Get small banner ad widget (for tutorial and start pages)
  /// Uses standard banner size (320x50)
  static Widget getSmallBannerAdWidget({double? padding}) {
    if (!shouldShowAds()) {
      return const SizedBox.shrink();
    }

    return BannerAdWidget(
      padding: padding ?? 8.0,
      adUnitId: _getBannerAdUnitId(),
      adSize: AdSize.banner, // Standard small banner size (320x50)
    );
  }

  /// Get native ad unit ID (Android & iOS). iOS: from Firebase Remote Config.
  static String _getNativeAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110'; // Android test ID
    }
    return FirebaseRemoteConfigService.iosAdUnitNative; // iOS: Remote Config
  }

  /// Get native ad widget (Android & iOS)
  /// Home screen ke baad sab jagah ye use hoga.
  static Widget getNativeAdWidget({
    double height = CricketAdConstants.adHeight,
  }) {
    final shouldShow = shouldShowAds();
    debugPrint('📢 getNativeAdWidget called - shouldShowAds: $shouldShow');
    if (Platform.isIOS) {
      debugPrint('📱 iOS: Native ad widget requested');
      debugPrint(
        '📱 iOS: ads_enabled_ios = ${FirebaseRemoteConfigService.iosAdsEnabled}',
      );
    }

    if (!shouldShow) {
      debugPrint('⚠️ Native ad widget not shown - ads disabled');
      return const SizedBox.shrink();
    }

    // Use a unique key to prevent widget rebuild issues
    debugPrint(
      '✅ Creating NativeAdWidget with adUnitId: ${_getNativeAdUnitId()}',
    );
    return NativeAdWidget(
      key: const ValueKey('native_ad_widget'),
      adUnitId: _getNativeAdUnitId(),
      height: height,
    );
  }

  /// Get banner ad unit ID. Android: test ID. iOS: from Firebase Remote Config.
  static String _getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android Test ID
    }
    return FirebaseRemoteConfigService.iosAdUnitBanner; // iOS: Remote Config
  }

  /// Get app-open ad unit ID. Android: test ID. iOS: from Firebase Remote Config.
  static String _getAppOpenAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9257395921'; // Android App Open Test ID
    }
    return FirebaseRemoteConfigService.iosAdUnitAppOpen; // iOS: Remote Config
  }

  /// Get interstitial ad unit ID. Android: test ID. iOS: from Firebase Remote Config.
  static String _getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android Test ID
    }
    return FirebaseRemoteConfigService.iosAdUnitInterstitial; // iOS: Remote Config
  }

  /// Load banner ad
  static Future<void> loadBannerAd() async {
    if (!shouldShowAds()) return;

    try {
      if (_bannerAd != null) {
        _bannerAd!.dispose();
      }

      _bannerAd = BannerAd(
        adUnitId: _getBannerAdUnitId(),
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            debugPrint('✅ Banner ad loaded');
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('❌ Banner ad failed to load: ${error.message}');
            if (Platform.isIOS && error.message.contains('No ad to show')) {
              debugPrint('⚠️ iOS: "No ad to show" is normal for newly approved ad units');
              debugPrint('⚠️ iOS: Ad units can take 24-72 hours to start serving ads');
              debugPrint('⚠️ iOS: This is expected - ads will work once inventory is ready');
            }
            ad.dispose();
          },
        ),
      );

      await _bannerAd!.load();
    } catch (e) {
      debugPrint('❌ Error loading banner ad: $e');
    }
  }

  /// Dispose banner ad
  static void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  /// Load app-open ad (called at app start and after each dismiss)
  static Future<void> loadAppOpenAd() async {
    if (!shouldShowAds() || _isShowingAppOpenAd) {
      return;
    }

    if (_isAppOpenAdReady && _appOpenAd != null) {
      return; // already have a ready ad
    }

    // Dispose existing ad if any before loading new one
    if (_appOpenAd != null) {
      try {
        _appOpenAd?.dispose();
      } catch (_) {
        // Ignore dispose errors
      }
      _appOpenAd = null;
      _isAppOpenAdReady = false;
    }

    // Don't load if already ready
    if (_isAppOpenAdReady) {
      return;
    }

    try {
      await AppOpenAd.load(
        adUnitId: _getAppOpenAdUnitId(),
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            _isAppOpenAdReady = true;
            _appOpenAdLoadAttempts = 0;
            debugPrint('✅ App-open ad loaded');

            // Set full screen content callbacks
            final adRef = ad;
            adRef.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                if (_appOpenAd == adRef) {
                  _isShowingAppOpenAd = true;
                  _lastAdShownTime = DateTime.now();
                  debugPrint('📢 App-open ad showed');
                  if (Platform.isIOS) {
                    debugPrint(
                      '⚠️ iOS: If ad not visible on screen, test on REAL device (simulator limitation)',
                    );
                  }
                }
              },
              onAdDismissedFullScreenContent: (ad) {
                // Check if this is still our ad (prevent "Ad with id 0" error)
                if (_appOpenAd == adRef && _isShowingAppOpenAd) {
                  _isShowingAppOpenAd = false;
                  try {
                    ad.dispose();
                  } catch (e) {
                    debugPrint('⚠️ Error disposing app-open ad: $e');
                  }
                  _appOpenAd = null;
                  _isAppOpenAdReady = false;
                  debugPrint(
                    '📢 App-open ad dismissed - normal app flow continues',
                  );
                  // Preload next ad for next foreground event
                  Future.delayed(const Duration(seconds: 1), () {
                    loadAppOpenAd();
                  });
                } else {
                  debugPrint(
                    '⚠️ Ad dismiss callback called but ad already disposed or not showing',
                  );
                }
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                if (_appOpenAd == adRef) {
                  _isShowingAppOpenAd = false;
                  try {
                    ad.dispose();
                  } catch (e) {
                    debugPrint('⚠️ Error disposing app-open ad: $e');
                  }
                  _appOpenAd = null;
                  _isAppOpenAdReady = false;
                  debugPrint('❌ App-open ad failed to show: ${error.message}');
                  if (Platform.isIOS) {
                    debugPrint('📱 iOS Debug Info:');
                    debugPrint('   - Error Code: ${error.code}');
                    debugPrint('   - Error Domain: ${error.domain}');
                    debugPrint('   - Error Message: ${error.message}');
                    debugPrint(
                      '   - Note: iOS App Open Ads may not work on simulator - test on real device',
                    );
                  }
                  // Preload next ad
                  Future.delayed(const Duration(seconds: 1), () {
                    loadAppOpenAd();
                  });
                }
              },
            );

            // Auto-show ad on first launch (cold start) - show immediately when loaded
            if (_isFirstLaunch) {
              _isFirstLaunch = false;
              debugPrint(
                '📢 First launch detected - will auto-show ad when ready',
              );
              if (Platform.isIOS) {
                debugPrint(
                  '⚠️ iOS: If ad not visible, you MUST test on REAL device (not simulator)',
                );
              }
              // Show ad immediately (no delay) - App Open Ad is full-screen and will cover splash
              Future.microtask(() {
                _showAppOpenAdOnFirstLaunch();
              });
            }
            // If ad was requested to show on load (foreground scenario), show it now
            else if (_shouldShowOnLoad) {
              _shouldShowOnLoad = false;
              debugPrint('📢 Ad loaded for foreground - auto-showing now...');
              Future.delayed(const Duration(milliseconds: 300), () {
                _tryShowAppOpenAd();
              });
            }
            // For subsequent foreground events, ad will be shown via showAppOpenAdIfReady()
          },
          onAdFailedToLoad: (error) {
            _isAppOpenAdReady = false;
            _appOpenAdLoadAttempts++;
            debugPrint(
              '❌ App-open ad failed to load: ${error.message} (attempt $_appOpenAdLoadAttempts)',
            );
            if (_appOpenAdLoadAttempts < _maxAppOpenAdLoadAttempts) {
              Future.delayed(const Duration(seconds: 2), () {
                loadAppOpenAd();
              });
            }
          },
        ),
      );
    } catch (e) {
      // Handle duplicate ad ID error (common after hot restart)
      final errorMessage = e.toString();
      if (errorMessage.contains('already exists')) {
        debugPrint(
          '⚠️ Duplicate app-open ad ID detected (likely from hot restart), skipping...',
        );
        // Don't retry immediately, wait a bit
        Future.delayed(const Duration(seconds: 2), () {
          if (!_isAppOpenAdReady && !_isShowingAppOpenAd) {
            loadAppOpenAd();
          }
        });
      } else {
        debugPrint('❌ Error loading app-open ad: $e');
      }

      // Cleanup on error
      try {
        _appOpenAd?.dispose();
      } catch (_) {
        // Ignore dispose errors
      }
      _appOpenAd = null;
      _isAppOpenAdReady = false;
    }
  }

  /// Show app-open ad on first launch (internal helper)
  static void _showAppOpenAdOnFirstLaunch() {
    if (!_isAppOpenAdReady || _appOpenAd == null || _isShowingAppOpenAd) {
      debugPrint(
        '⚠️ Cannot show ad on first launch: ready=$_isAppOpenAdReady, ad=${_appOpenAd != null}, showing=$_isShowingAppOpenAd',
      );
      return;
    }

    try {
      debugPrint('📢 Showing app-open ad on first launch...');
      if (Platform.isIOS) {
        debugPrint(
          '📱 iOS Note: App Open Ads may not display on simulator - test on real device',
        );
      }
      _appOpenAd!.show();
      debugPrint(
        '✅ App-open ad show() called successfully - ad should appear now',
      );
      if (Platform.isIOS) {
        debugPrint(
          '📱 iOS: If ad not visible, check: 1) Real device (not simulator), 2) Network connection, 3) AdX account status',
        );
      }
    } catch (e) {
      debugPrint('❌ Error showing app-open ad on first launch: $e');
      if (Platform.isIOS) {
        debugPrint(
          '📱 iOS Debug: App Open Ads require real device - simulator may not show ads',
        );
      }
      _isAppOpenAdReady = false;
      try {
        _appOpenAd?.dispose();
      } catch (_) {}
      _appOpenAd = null;
    }
  }

  /// Show app-open ad if ready (called when app comes to foreground)
  /// Prevents back-to-back ads and ensures only one ad shows at a time
  static Future<void> showAppOpenAdIfReady() async {
    // Check if ads are enabled (Android only for now)
    if (!shouldShowAds()) {
      return;
    }

    // Don't show if already showing
    if (_isShowingAppOpenAd) {
      debugPrint('⚠️ App-open ad already showing, skipping');
      return;
    }

    // Prevent immediate re-show (wait 10 seconds after user closes ad)
    // This prevents showing ad right after user just dismissed it
    if (_lastAdShownTime != null) {
      final timeSinceLastAd = DateTime.now().difference(_lastAdShownTime!);
      if (timeSinceLastAd < _minTimeBetweenAds) {
        debugPrint(
          '⚠️ Skipping app-open ad - just closed ${timeSinceLastAd.inSeconds}s ago (wait ${_minTimeBetweenAds.inSeconds}s)',
        );
        return;
      }
    }

    // If ad not ready, load it first (for foreground scenario)
    if (!_isAppOpenAdReady || _appOpenAd == null) {
      debugPrint('⚠️ App-open ad not ready on foreground - loading now...');
      // Set flag to auto-show when ad loads
      _shouldShowOnLoad = true;
      // Load ad - it will auto-show when loaded (see onAdLoaded callback)
      loadAppOpenAd();
      return;
    }

    // Ad is ready - show it immediately
    _tryShowAppOpenAd();
  }

  /// Internal helper to show app-open ad (with error handling)
  static void _tryShowAppOpenAd() {
    if (!_isAppOpenAdReady || _appOpenAd == null || _isShowingAppOpenAd) {
      debugPrint(
        '⚠️ Cannot show ad: ready=$_isAppOpenAdReady, ad=${_appOpenAd != null}, showing=$_isShowingAppOpenAd',
      );
      return;
    }

    try {
      debugPrint('📢 Showing app-open ad on foreground...');
      if (Platform.isIOS) {
        debugPrint(
          '📱 iOS Note: App Open Ads may not display on simulator - test on real device',
        );
      }
      _appOpenAd!.show();
      debugPrint('✅ App-open ad show() called successfully');
      if (Platform.isIOS) {
        debugPrint(
          '📱 iOS: If ad not visible, check: 1) Real device (not simulator), 2) Network connection, 3) AdX account status',
        );
      }
    } catch (e) {
      debugPrint('❌ Error showing app-open ad: $e');
      if (Platform.isIOS) {
        debugPrint(
          '📱 iOS Debug: App Open Ads require real device - simulator may not show ads',
        );
      }
      // Cleanup on error - app continues normally
      _isAppOpenAdReady = false;
      try {
        _appOpenAd?.dispose();
      } catch (_) {
        // Ignore dispose errors
      }
      _appOpenAd = null;
      // Preload next ad
      Future.delayed(const Duration(seconds: 1), () {
        loadAppOpenAd();
      });
    }
  }

  /// Load interstitial ad
  /// Android: Check ads_enabled_android
  /// iOS: Check ads_enabled_ios
  static Future<void> loadInterstitialAd() async {
    if (!shouldShowAds() || _isLoadingInterstitial) {
      return;
    }

    // Dispose existing ad if any before loading new one
    if (_interstitialAd != null) {
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
    }

    // Don't load if already ready
    if (_isInterstitialAdReady) {
      return;
    }

    _isLoadingInterstitial = true;

    try {
      await InterstitialAd.load(
        adUnitId: _getInterstitialAdUnitId(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
            _isLoadingInterstitial = false;
            debugPrint('✅ Interstitial ad loaded');

            // Set full screen content callbacks
            // Store ad reference locally to avoid null issues
            final adRef = ad;
            adRef.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                // Check if ad is still valid before accessing
                if (_interstitialAd == adRef) {
                  debugPrint('📢 Interstitial ad showed');
                }
              },
              onAdDismissedFullScreenContent: (ad) {
                // Only process if this is still the current ad
                if (_interstitialAd == adRef) {
                  try {
                    ad.dispose();
                  } catch (e) {
                    debugPrint('⚠️ Error disposing interstitial ad: $e');
                  }
                  _interstitialAd = null;
                  _isInterstitialAdReady = false;
                  _isLoadingInterstitial = false;
                  debugPrint('📢 Interstitial ad dismissed');
                  // Load next interstitial ad after a short delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (!_isLoadingInterstitial && !_isInterstitialAdReady) {
                      loadInterstitialAd();
                    }
                  });
                }
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                // Only process if this is still the current ad
                if (_interstitialAd == adRef) {
                  try {
                    ad.dispose();
                  } catch (e) {
                    debugPrint('⚠️ Error disposing interstitial ad: $e');
                  }
                  _interstitialAd = null;
                  _isInterstitialAdReady = false;
                  _isLoadingInterstitial = false;
                  debugPrint(
                    '❌ Interstitial ad failed to show: ${error.message}',
                  );
                  // Load next interstitial ad after a short delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (!_isLoadingInterstitial && !_isInterstitialAdReady) {
                      loadInterstitialAd();
                    }
                  });
                }
              },
            );
          },
          onAdFailedToLoad: (error) {
            _isInterstitialAdReady = false;
            _isLoadingInterstitial = false;
            debugPrint('❌ Interstitial ad failed to load: ${error.message}');
          },
        ),
      );
    } catch (e) {
      // Handle duplicate ad ID error (common after hot restart)
      final errorMessage = e.toString();
      if (errorMessage.contains('already exists')) {
        debugPrint(
          '⚠️ Duplicate interstitial ad ID detected (likely from hot restart), skipping...',
        );
        // Don't retry immediately, wait a bit
        Future.delayed(const Duration(seconds: 2), () {
          if (!_isLoadingInterstitial && !_isInterstitialAdReady) {
            loadInterstitialAd();
          }
        });
      } else {
        debugPrint('❌ Error loading interstitial ad: $e');
      }

      // Cleanup on error
      try {
        _interstitialAd?.dispose();
      } catch (_) {
        // Ignore dispose errors
      }
      _interstitialAd = null;
      _isInterstitialAdReady = false;
      _isLoadingInterstitial = false;
    }
  }

  /// Show interstitial ad immediately on button click
  /// Android: Check ads_enabled_android
  /// iOS: Check ads_enabled_ios
  /// Call this when navigating to a new screen/activity
  static Future<void> showInterstitialAdIfNeeded({String? screenName}) async {
    if (!shouldShowAds()) {
      return;
    }

    // Increment screen view count (for analytics)
    incrementScreenView();

    // Show ad immediately if ready
    if (_isInterstitialAdReady && _interstitialAd != null) {
      try {
        await _interstitialAd!.show();
        if (screenName != null) {
          debugPrint('📢 Showing interstitial ad for screen: $screenName');
        }
        // Reset ready state - will be reloaded after ad is dismissed
        _isInterstitialAdReady = false;
      } catch (e) {
        debugPrint('❌ Error showing interstitial ad: $e');
        // Dispose and reload on error
        _interstitialAd?.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
        loadInterstitialAd();
      }
    } else {
      // If ad not ready, load it for next time
      if (!_isLoadingInterstitial) {
        loadInterstitialAd();
      }
    }
  }

  /// Preload interstitial ad (call this early to have ad ready)
  static void preloadInterstitialAd() {
    if (!_isInterstitialAdReady && !_isLoadingInterstitial) {
      loadInterstitialAd();
    }
  }

  /// Reset screen view count
  static void resetScreenViewCount() {
    _screenViewCount = 0;
  }

  /// Dispose all ads
  static void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isAppOpenAdReady = false;
    _isInterstitialAdReady = false;
    _isLoadingInterstitial = false;
    _isShowingAppOpenAd = false;
    _lastAdShownTime = null;
    _appOpenAdLoadAttempts = 0;
    _screenViewCount = 0;
  }
}
