import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'constants/cricket_colors.dart';
import 'shared/services/firebase_analytics_service.dart';
import 'shared/services/cricket_ad_service.dart';

/// Main Cricket App Entry Point
/// This is the root widget for the cricket app feature
class CricketApp extends StatefulWidget {
  const CricketApp({super.key});

  @override
  State<CricketApp> createState() => _CricketAppState();
}

class _CricketAppState extends State<CricketApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Log app open event when app first loads
    FirebaseAnalyticsService.logAppOpen();

    // App Open Ad: Try to show on first launch (fallback if auto-show didn't work)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Try multiple times to ensure ad shows (ad loads in 1-3 seconds)
      Future.delayed(const Duration(milliseconds: 800), () {
        CricketAdService.showAppOpenAdIfReady();
      });
      Future.delayed(const Duration(seconds: 2), () {
        CricketAdService.showAppOpenAdIfReady();
      });
    });
  }

  @override
  void dispose() {
    // Log app close event when app is disposed
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Track app lifecycle events for Firebase Analytics
    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground - show App Open Ad (if ready and not too soon)

        // App Open Ad shows BEFORE home screen when app comes to foreground
        CricketAdService.showAppOpenAdIfReady();
        break;
      case AppLifecycleState.paused:
        // App went to background - preload ad for next foreground
        // Preload app-open ad so it's ready when user comes back
        CricketAdService.loadAppOpenAd();
        break;
      case AppLifecycleState.inactive:
        // App is transitioning (e.g., incoming call)
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        break;
      case AppLifecycleState.hidden:
        // App is hidden (iOS 17+)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket App',
      debugShowCheckedModeBanner: false,
      // Add analytics observer for automatic screen tracking
      navigatorObservers: [
        if (FirebaseAnalyticsService.observer != null)
          FirebaseAnalyticsService.observer!,
      ],
      theme: ThemeData(
        primaryColor: CricketColors.primaryGreen,
        scaffoldBackgroundColor: CricketColors.backgroundDark,
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: CricketColors.primaryGreen,
          background: CricketColors.backgroundDark,
          surface: CricketColors.cardBackground,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
