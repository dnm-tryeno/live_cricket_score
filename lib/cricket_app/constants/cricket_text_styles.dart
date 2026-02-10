import 'package:flutter/material.dart';
import 'cricket_colors.dart';

/// Cricket App Text Styles
/// Based on demo designs
class CricketTextStyles {
  CricketTextStyles._();

  // Headlines
  static TextStyle get headlineLarge => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: CricketColors.textWhite,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: CricketColors.textWhite,
        letterSpacing: -0.3,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: CricketColors.textWhite,
      );

  // Body Text
  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: CricketColors.textWhite,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: CricketColors.textWhite,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: CricketColors.textGrey,
      );

  // Score Text
  static TextStyle get scoreLarge => const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: CricketColors.textWhite,
        letterSpacing: -1,
      );

  static TextStyle get scoreMedium => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: CricketColors.textWhite,
      );

  // Button Text
  static TextStyle get buttonLarge => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: CricketColors.textWhite,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: CricketColors.textWhite,
      );

  // Label Text
  static TextStyle get labelLarge => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: CricketColors.textWhite,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: CricketColors.textGrey,
      );

  // Live Indicator
  static TextStyle get liveIndicator => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: CricketColors.liveIndicator,
        letterSpacing: 0.5,
      );

  // Green Accent Text
  static TextStyle get accentGreen => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: CricketColors.primaryGreen,
      );
}
