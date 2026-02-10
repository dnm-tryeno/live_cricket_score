import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static SharedPreferences? _sharedPreferences;
  static const String _loginTokenKey = 'web_cookie_id_token';
  static const String _tutorialCompletedKey = 'tutorial_completed';
  static const String _selectedUnitKey = 'selected_unit';
  static const String _playStoreLaunchedKey = 'play_store_launched';
  static const String _cachedLocationKey = 'cached_location';
  static const String _cachedLocationTimestampKey = 'cached_location_timestamp';

  // Initialize shared preferences instance
  static Future<void> init() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('⚠️ Error initializing SharedPreferences: $e');
      rethrow;
    }
  }

  static Future<void> _clearAllPreferences() async {
    if (_sharedPreferences == null) return;
    await _sharedPreferences!.clear();
  }

  // Logout and clear preferences
  static Future<void> clearOnLogout() async {
    await _clearAllPreferences();
  }

  // ----------------------------------------
  // Token helpers
  // ----------------------------------------

  static Future<void> saveLoginToken(String token) async {
    if (_sharedPreferences == null) {
      debugPrint('⚠️ SharedPreferences not initialized');
      return;
    }
    await _sharedPreferences!.setString(_loginTokenKey, token);
    debugPrint('🔐 Saved login token (${token.length} chars)');
  }

  static Future<String?> getLoginToken() async {
    if (_sharedPreferences == null) {
      debugPrint('⚠️ SharedPreferences not initialized');
      return null;
    }
    final v = _sharedPreferences!.getString(_loginTokenKey);
    return (v != null && v.isNotEmpty) ? v : null;
  }

  static Future<void> clearLoginToken() async {
    await _sharedPreferences!.remove(_loginTokenKey);
    debugPrint('🔓 Cleared login token');
  }

  // ----------------------------------------
  // Tutorial helpers
  // ----------------------------------------

  static Future<void> setTutorialCompleted(bool completed) async {
    await _sharedPreferences!.setBool(_tutorialCompletedKey, completed);
    debugPrint('📚 Tutorial completed status: $completed');
  }

  static Future<bool> isTutorialCompleted() async {
    if (_sharedPreferences == null) {
      debugPrint('⚠️ SharedPreferences not initialized, defaulting to false');
      return false;
    }
    final v = _sharedPreferences!.getBool(_tutorialCompletedKey);
    return v ?? false;
  }

  // ----------------------------------------
  // Speed unit helpers
  // ----------------------------------------

  static Future<void> setSelectedUnit(String unit) async {
    await _sharedPreferences!.setString(_selectedUnitKey, unit);
    debugPrint('📏 Saved selected unit: $unit');
  }

  static Future<String> getSelectedUnit() async {
    final v = _sharedPreferences!.getString(_selectedUnitKey);
    return v ?? 'Mbps'; // Default to Mbps
  }

  // ----------------------------------------
  // Play Store launch helpers
  // ----------------------------------------

  static Future<void> setPlayStoreLaunched(bool launched) async {
    await _sharedPreferences!.setBool(_playStoreLaunchedKey, launched);
    debugPrint('🏪 Play Store launched status: $launched');
  }

  static Future<bool> isPlayStoreLaunched() async {
    final v = _sharedPreferences!.getBool(_playStoreLaunchedKey);
    return v ?? false;
  }

  // ----------------------------------------
  // Location caching helpers
  // ----------------------------------------

  static Future<void> setCachedLocation(String location) async {
    await Future.wait([
      _sharedPreferences!.setString(_cachedLocationKey, location),
      _sharedPreferences!.setInt(
        _cachedLocationTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      ),
    ]);
    debugPrint('📍 Cached location: $location');
  }

  static Future<String?> getCachedLocation() async {
    final location = _sharedPreferences!.getString(_cachedLocationKey);
    final timestamp = _sharedPreferences!.getInt(_cachedLocationTimestampKey);

    if (location != null && timestamp != null) {
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cachedTime);

      // Cache valid for 1 hour
      if (difference.inHours < 1) {
        debugPrint('📍 Using cached location: $location');
        return location;
      }
    }

    return null;
  }
}
