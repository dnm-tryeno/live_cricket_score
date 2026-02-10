import 'package:flutter/material.dart';

/// Cricket App Color Constants
/// Based on demo designs: Dark theme with green/red accents
class CricketColors {
  CricketColors._();

  // Primary Colors
  static const Color primaryGreen = Color(0xFF00FF88); // Vibrant green for accents
  static const Color darkGreen = Color(0xFF0A1F0A); // Dark green background
  static const Color darkerGreen = Color(0xFF051405); // Darker green for cards
  
  // Accent Colors
  static const Color accentRed = Color(0xFFF24747); // Lighter red for UI elements
  static const Color accentBlue = Color(0xFF0066FF); // Blue for team badges, sixes
  static const Color accentGreen = Color(0xFF4CAF50); // Green for completed/success
  static const Color accentYellow = Color(0xFFFFD700); // Yellow for team badges
  
  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF999999);
  static const Color textLightGrey = Color(0xFFCCCCCC);
  
  // Background Colors
  static const Color backgroundDark = Color(0xFF111111); // Main dark background
  static const Color cardBackground = Color(0xFF1A1A1A); // Card background
  static const Color cardBackgroundLight = Color(0xFF2A2A2A); // Lighter card background
  
  // Status Colors
  static const Color liveIndicator = Color(0xFFF24747); // Lighter red for live indicator
  static const Color boundaryGreen = Color(0xFF00FF88);
  static const Color sixBlue = Color(0xFF0066FF);
  static const Color wicketRed = Color(0xFFF24747); // Lighter red for wickets
  
  // Border Colors
  static const Color borderGrey = Color(0xFF333333);
  static const Color borderGreen = Color(0xFF00FF88);

  // Light theme (home / All Matches screens)
  static const Color backgroundLight = Color(0xFFF0F2F7);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF1A1A1A);
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryBlue = Color(0xFF284288);
  static const Color liveCardBlue = Color(0xFFE8F4FC); // light blue for live match card
  
  // Overlay Colors
  static const Color overlayDark = Color(0x80000000);
}
