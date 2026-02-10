import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/cricket_app/constants/cricket_ad_constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static const String bannerAdUnitId = 'ca-app-pub-3422720384917984/7003147105';
  static const String rewardedAdUnitId =
      'ca-app-pub-3422720384917984/1835399144';

  static String get bannerAdId => bannerAdUnitId;
  static String get rewardedAdId => rewardedAdUnitId;

  // Test Device IDs - Add your device IDs here for testing
  // Check logcat for: "Use RequestConfiguration.Builder().setTestDeviceIds"
  // Format: "XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX"
  static const List<String> testDeviceIds = [
    // Add your test device IDs here
    // Example: '68430A10862671400F0D0E0A7A2FAFA4',
  ];

  /// Configure AdMob with test devices
  /// Call this during app initialization for testing
  static void configureTestDevices() {
    if (testDeviceIds.isNotEmpty) {
      final configuration = RequestConfiguration(testDeviceIds: testDeviceIds);
      MobileAds.instance.updateRequestConfiguration(configuration);
    }
  }
}

/// Banner Ad Widget
class BannerAdWidget extends StatefulWidget {
  final AdSize? adSize;
  final String? adUnitId;
  final double? padding;

  const BannerAdWidget({super.key, this.adSize, this.adUnitId, this.padding});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  int _numBannerLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;
  AdSize? _adSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAdSize();
    });
  }

  Future<void> _initializeAdSize() async {
    if (!mounted) return;

    try {
      if (widget.adSize != null) {
        _adSize = widget.adSize;
        _loadBannerAd();
      } else {
        // Force a tall banner (card-style) similar to the reference UI.
        // We skip the small adaptive banner height and always use ~250px.
        final screenWidth = MediaQuery.of(context).size.width;
        final paddingValue = widget.padding ?? 16.0;
        final availableWidth = (screenWidth - (paddingValue * 2)).toInt();

        _adSize = AdSize(
          width: availableWidth,
          height: CricketAdConstants.adHeight.toInt(),
        );

        if (mounted) {
          _loadBannerAd();
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error initializing ad size: $e');
      // Don't load ad if initialization fails
    }
  }

  Future<void> _loadBannerAd() async {
    if (_adSize == null) return;

    // Dispose existing ad before creating new one (prevents duplicate ad ID error)
    if (_bannerAd != null) {
      try {
        _bannerAd?.dispose();
      } catch (e) {
        debugPrint('⚠️ Error disposing old banner ad: $e');
      }
      _bannerAd = null;
      _isLoaded = false;
    }

    try {
      _bannerAd = BannerAd(
        adUnitId: widget.adUnitId ?? AdMobService.bannerAdId,
        size: _adSize!,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            if (mounted) {
              setState(() {
                _isLoaded = true;
                _numBannerLoadAttempts = 0;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('⚠️ Banner ad failed to load: ${error.message}');
            ad.dispose();
            _numBannerLoadAttempts += 1;
            if (mounted) {
              setState(() {
                _isLoaded = false;
              });
              if (_numBannerLoadAttempts < maxFailedLoadAttempts) {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  if (mounted) {
                    _loadBannerAd();
                  }
                });
              }
            }
          },
          onAdOpened: (_) {},
          onAdClosed: (_) {},
        ),
      );

      // Await the load so that PlatformException from the plugin
      // is caught here instead of crashing the app (e.g. after hot restart
      // when an old ad with the same internal ID still exists).
      await _bannerAd!.load();
    } catch (e) {
      // Handle duplicate ad ID error (common after hot restart)
      final errorMessage = e.toString();
      if (errorMessage.contains('already exists')) {
        debugPrint(
          '⚠️ Duplicate ad ID detected (likely from hot restart), skipping...',
        );
        // Don't retry immediately, wait a bit
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _bannerAd == null) {
            _loadBannerAd();
          }
        });
      } else {
        debugPrint('⚠️ Error loading banner ad: $e');
      }
      // Dispose on error to prevent duplicate ad ID issues
      try {
        _bannerAd?.dispose();
      } catch (_) {
        // Ignore dispose errors
      }
      _bannerAd = null;
      _isLoaded = false;
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null || _adSize == null) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final adHeight = _adSize!.height.toDouble();
    final paddingValue = widget.padding ?? 16.0;
    final availableWidth = screenWidth - (paddingValue * 2);

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: Container(
        width: availableWidth,
        height: adHeight,
        decoration: BoxDecoration(
          color: const Color(0xFF0F1D26),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ColoredBox(
            color: const Color(0xFF0F1D26),
            child: SizedBox(
              width: availableWidth,
              height: adHeight,
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
        ),
      ),
    );
  }
}

/// Native Ad Widget (Android & iOS)
/// Uses Google test native ID by default; replace with production ID later.
class NativeAdWidget extends StatefulWidget {
  final String? adUnitId;
  final double? height;

  const NativeAdWidget({super.key, this.adUnitId, this.height});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  bool _isLoading = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🔄 NativeAdWidget initState called');
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      debugPrint('📱 iOS: NativeAdWidget initializing');
      debugPrint(
        '📱 iOS: Ad unit ID will be: ${widget.adUnitId ?? "ca-app-pub-3940256099942544/3986624511"}',
      );
      debugPrint(
        '📱 iOS: Factory ID: listTile (should be registered in AppDelegate.swift)',
      );
    }

    // Load native ads for both Android and iOS
    // Load asynchronously so that PlatformException during load
    // can be caught and app crash na ho.
    Future.microtask(_loadNativeAd);
  }

  Future<void> _loadNativeAd() async {
    debugPrint('🔄 _loadNativeAd() called');
    if (_isLoading || _isDisposed) {
      debugPrint('⚠️ Native ad already loading or widget disposed');
      return;
    }

    try {
      _isLoading = true;
      debugPrint('✅ Starting native ad load...');

      // Dispose existing ad if any (to prevent duplicate ad ID errors)
      if (_nativeAd != null) {
        try {
          _nativeAd!.dispose();
        } catch (e) {
          debugPrint('⚠️ Error disposing old native ad: $e');
        }
      }

      _nativeAd = null;
      _isLoaded = false;

      debugPrint('🔄 Loading native ad...');
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        debugPrint(
          '📱 iOS: Using test ad unit ID: ca-app-pub-3940256099942544/3986624511',
        );
        debugPrint(
          '📱 iOS: Factory ID: listTile (should be registered in AppDelegate.swift)',
        );
        debugPrint('📱 iOS: Check Xcode console for factory registration log');
      }

      // Get platform-specific test ID if not provided
      final defaultAdUnitId = defaultTargetPlatform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/2247696110' // Android native test ID
          : 'ca-app-pub-3940256099942544/3986624511'; // iOS native test ID (AdX)

      _nativeAd = NativeAd(
        adUnitId: widget.adUnitId ?? defaultAdUnitId,
        // NOTE: Both Android and iOS require NativeAdFactory with factoryId 'listTile'
        // Android: Registered in MainActivity.kt
        // iOS: Registered in AppDelegate.swift
        factoryId: 'listTile', // Same factory ID for both platforms
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            if (_isDisposed || !mounted) {
              debugPrint('⚠️ Widget disposed or unmounted, disposing ad');
              ad.dispose();
              return;
            }
            debugPrint('✅ Native ad loaded successfully');
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              debugPrint(
                '📱 iOS: Native ad factory registered with id: listTile',
              );
            }
            if (mounted) {
              setState(() {
                _isLoaded = true;
                _isLoading = false;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('⚠️ Native ad failed to load: ${error.message}');
            debugPrint('⚠️ Error code: ${error.code}, domain: ${error.domain}');
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              debugPrint('📱 iOS Debug: Native ad failed to load');
              debugPrint(
                '📱 iOS: Check if native factory is registered in AppDelegate.swift',
              );
              debugPrint('📱 iOS: Factory ID should be "listTile"');
              debugPrint(
                '📱 iOS: Make sure FLTGoogleMobileAdsPlugin.registerNativeAdFactory is called',
              );
              debugPrint(
                '📱 iOS: Check Xcode console for Swift print statements',
              );
              if (error.message.contains('factory') ||
                  error.message.contains('Factory') ||
                  error.message.contains('nativeAdFactory') ||
                  error.message.contains('No factory')) {
                debugPrint('❌ iOS: Native ad factory not found!');
                debugPrint(
                  '❌ iOS: Verify AppDelegate.swift has factory registration',
                );
                debugPrint(
                  '❌ iOS: Factory must be registered BEFORE super.application() call',
                );
              }
              if (error.message.contains('format') ||
                  error.message.contains('invalid')) {
                debugPrint(
                  '❌ iOS: Ad unit ID format issue - using test ID: ca-app-pub-3940256099942544/3986624511',
                );
              }
            }
            try {
              ad.dispose();
            } catch (e) {
              debugPrint('⚠️ Error disposing failed ad: $e');
            }
            if (mounted && !_isDisposed) {
              setState(() {
                _isLoaded = false;
                _isLoading = false;
              });
            }
          },
          onAdClicked: (ad) {
            debugPrint('📢 Native ad clicked');
          },
          onAdImpression: (ad) {
            debugPrint('👁️ Native ad impression recorded');
          },
        ),
      );

      // Await load so any PlatformException (e.g. missing NativeAdFactory)
      // is caught here instead of becoming an unhandled exception.
      await _nativeAd!.load();
    } catch (e) {
      debugPrint('⚠️ Error loading native ad: $e');
      // Cleanup on error
      try {
        _nativeAd?.dispose();
      } catch (_) {}
      _nativeAd = null;
      if (mounted && !_isDisposed) {
        setState(() {
          _isLoaded = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    debugPrint('🗑️ Disposing NativeAdWidget');
    try {
      _nativeAd?.dispose();
    } catch (e) {
      debugPrint('⚠️ Error disposing native ad: $e');
    }
    _nativeAd = null;
    _isLoaded = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't render if disposed
    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    // Show loading indicator while loading
    if (_isLoading) {
      return SizedBox(
        height: widget.height ?? 250,
        width: double.infinity,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show ad if loaded
    if (_isLoaded && _nativeAd != null) {
      final double height = widget.height ?? 250;
      debugPrint('✅ Rendering native ad widget with height: $height');
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        debugPrint('📱 iOS: Native ad loaded and rendering');
        debugPrint('📱 iOS: AdWidget should display native ad view');
        debugPrint('📱 iOS: If not visible on real device:');
        debugPrint('   1. Check Xcode console for Swift print statements');
        debugPrint(
          '   2. Verify factory is registered (look for "✅ iOS Native Ad Factory registered")',
        );
        debugPrint('   3. Check if createNativeAd is being called');
        debugPrint('   4. Verify views are not hidden (isHidden = false)');
      }

      return SizedBox(
        height: height,
        width: double.infinity,
        child: AdWidget(ad: _nativeAd!),
      );
    }

    // Show empty if not loaded
    debugPrint(
      '⚠️ Native ad not loaded yet (isLoading: $_isLoading, isLoaded: $_isLoaded, ad: ${_nativeAd != null})',
    );
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      debugPrint('📱 iOS: Waiting for native ad to load...');
      debugPrint('📱 iOS: Check console for loading errors');
    }
    return const SizedBox.shrink();
  }
}

/// Rewarded Ad Service
class RewardedAdService {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  bool _isReady = false;
  Function()? _onAdDismissedCallback;
  int _numRewardedLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  /// Load a rewarded ad
  Future<void> loadRewardedAd() async {
    if (_isLoading || _isReady) return;

    _isLoading = true;

    try {
      await RewardedAd.load(
        adUnitId: AdMobService.rewardedAdId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isReady = true;
            _isLoading = false;
            _numRewardedLoadAttempts = 0;

            _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                _onAdDismissedCallback?.call();
                _onAdDismissedCallback = null;
                ad.dispose();
                _rewardedAd = null;
                _isReady = false;
                _createRewardedAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                _onAdDismissedCallback?.call();
                _onAdDismissedCallback = null;
                ad.dispose();
                _rewardedAd = null;
                _isReady = false;
                _createRewardedAd();
              },
              onAdShowedFullScreenContent: (_) {},
            );
          },
          onAdFailedToLoad: (error) {
            _rewardedAd = null;
            _isLoading = false;
            _isReady = false;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ),
      );
    } catch (e) {
      _isLoading = false;
      _isReady = false;
      _numRewardedLoadAttempts += 1;
      if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
        _createRewardedAd();
      }
    }
  }

  void _createRewardedAd() {
    Future.delayed(const Duration(milliseconds: 500), () {
      loadRewardedAd();
    });
  }

  /// Show rewarded ad
  /// Returns true if ad was shown, false otherwise
  Future<bool> showRewardedAd({
    required Function(RewardItem) onRewarded,
    Function()? onAdDismissed,
    Function(String)? onError,
  }) async {
    if (!_isReady || _rewardedAd == null) {
      await loadRewardedAd();
      if (!_isReady || _rewardedAd == null) {
        onError?.call('Ad not ready');
        return false;
      }
    }

    try {
      _onAdDismissedCallback = onAdDismissed;
      _rewardedAd?.setImmersiveMode(true);

      _rewardedAd?.show(
        onUserEarnedReward: (ad, reward) {
          onRewarded(reward);
        },
      );
      _rewardedAd = null;
      _isReady = false;
      return true;
    } catch (e) {
      _onAdDismissedCallback?.call();
      _onAdDismissedCallback = null;
      onError?.call(e.toString());
      return false;
    }
  }

  /// Check if ad is ready
  bool get isReady => _isReady && _rewardedAd != null;

  /// Dispose the ad
  void dispose() {
    _onAdDismissedCallback = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isReady = false;
    _isLoading = false;
    _numRewardedLoadAttempts = 0;
  }
}
