import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_project/data/local/shared_pref/my_shared_preferences.dart';
import 'package:flutter_project/feature/shared/navigation/app_router.dart';
import 'package:flutter_project/my_app.dart';
import 'package:flutter_project/cricket_app/cricket_app.dart';
import 'package:flutter_project/cricket_app/shared/services/firebase_analytics_service.dart';
import 'package:flutter_project/cricket_app/shared/services/firebase_remote_config_service.dart';
import 'package:flutter_project/cricket_app/shared/services/cricket_ad_service.dart';
import 'package:flutter_project/firebase_options_prod.dart';

// Set this to true to launch Cricket App instead of main app
const bool launchCricketApp = true;

Future<void> sharedMain({List<dynamic> overrides = const []}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env (CRICKET_API_KEY etc.) - fails if .env missing or empty
  await dotenv.load(fileName: '.env');

  // Initialize SharedPreferences
  await SharedPrefManager.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase for both iOS and Android
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Firebase Analytics (for both platforms)
    await FirebaseAnalyticsService.initialize();

    // Initialize Remote Config (needed for ad/feature flags; safe on Android+iOS)
    await FirebaseRemoteConfigService.initialize();
    
    if (kDebugMode) {
      debugPrint('✅ Firebase initialized for ${Platform.isIOS ? "iOS" : "Android"}');
    }
  } catch (e) {
    debugPrint('⚠️ Firebase initialization error: $e');
    debugPrint('ℹ️ Make sure to run: flutterfire configure');
  }

  // Initialize Cricket ad service (App Open, interstitial, banners) when launching cricket app
  if (launchCricketApp) {
    await CricketAdService.initialize();
  }

  // Launch Cricket App if flag is set
  if (launchCricketApp) {
    runApp(const ProviderScope(child: CricketApp()));
    return;
  }

  final appRouter = AppRouter();

  runApp(MyApp(appRouter: appRouter));
}
