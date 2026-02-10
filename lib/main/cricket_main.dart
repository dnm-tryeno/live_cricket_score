import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_project/cricket_app/cricket_app.dart';
import 'package:flutter_project/cricket_app/shared/services/firebase_analytics_service.dart';
import 'package:flutter_project/cricket_app/shared/services/firebase_remote_config_service.dart';
import 'package:flutter_project/cricket_app/shared/services/cricket_ad_service.dart';
import 'package:flutter_project/firebase_options_prod.dart';

/// Cricket App Main Entry Point
/// To run cricket app, use this file as entry point
/// Or modify shared_main.dart to conditionally launch cricket app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env (CRICKET_API_KEY etc.) - fails if .env missing or empty
  await dotenv.load(fileName: '.env');

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
    
    // Initialize Remote Config (iOS: for AdEx; needed for shouldShowAppOpenAd on iOS)
    await FirebaseRemoteConfigService.initialize();

    if (kDebugMode) {
      debugPrint('✅ Firebase initialized for ${Platform.isIOS ? "iOS" : "Android"}');
    }
  } catch (e) {
    debugPrint('⚠️ Firebase initialization error: $e');
    debugPrint('ℹ️ Make sure to run: flutterfire configure');
  }
  
  // Initialize Ad Service (works for both platforms)
  await CricketAdService.initialize();

  runApp(const ProviderScope(child: CricketApp()));
}
