import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/feature/shared/utils/styles/app_color.dart';

class AppThemes {
  static ThemeData appTheme(
    Brightness brightness, {
    Color? statusBarColor,
    Color? appBarColor,
  }) {
    final colors = brightness == Brightness.light
        ? AppColor.lightColor
        : AppColor.darkColor;

    // Set the system UI overlay style with dark theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            statusBarColor ?? const Color(0xFF0F1D26), // Dark app background
        statusBarIconBrightness:
            Brightness.light, // White icons for dark background
        statusBarBrightness: Brightness.dark, // Required for iOS
        systemNavigationBarColor: const Color(
          0xFF0F1D26,
        ), // Match app background
        systemNavigationBarIconBrightness:
            Brightness.light, // White navigation icons
      ),
    );

    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF0F1D26),
      appBarTheme: AppBarTheme(
        backgroundColor:
            appBarColor ?? colors.darkBlueColor, // Custom AppBar color
      ),
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 0.5),
      fontFamily: 'Poppins',
    );
  }
}
