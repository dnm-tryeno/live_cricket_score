import 'package:flutter/material.dart';
import '../constants.dart';

class AppTextStyle {
  const AppTextStyle._();

  static const TextStyle bodyExtraLarge = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 45.0,
  );
  static const TextStyle bodyExtraLargeText = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 25.0,
  );

  static const TextStyle bodyLargeText = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 22.0,
  );

  static const TextStyle bodySmallText = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 20.0,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 18.0,
  );

  static const TextStyle titleLargeText = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 17.0,
  );

  static const TextStyle titleLargeMedium = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 16.0,
  );
  static const TextStyle titleMediumText = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 15.0,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 14.0,
  );
  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 13.0,
  );

  static const TextStyle titleSmallText = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 12.0,
  );

  static const TextStyle semiTitleLargeText = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 10.0,
  );

  static const TextStyle semiTitleMediumText = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 8.0,
  );

  static const TextStyle semiTitleSmallText = TextStyle(
    fontFamily: AppConstants.fontFamilyInter,
    fontSize: 6.0,
  );

  // ---------- SF Pro Font Styles ----------
  static const TextStyle arialTitleMediumText = TextStyle(
    fontFamily: AppConstants.fontFamilySFPro,
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
    textBaseline: TextBaseline.alphabetic,
  );

  static const TextStyle arialBodySmallText = TextStyle(
    fontFamily: AppConstants.fontFamilySFPro,
    fontSize: 20.0,
    height: 1.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    textBaseline: TextBaseline.alphabetic,
  );

  static const TextStyle arialTitleLargeText = TextStyle(
    fontFamily: AppConstants.fontFamilySFPro,
    fontWeight: FontWeight.w700,
    fontSize: 10.0,
    height: 22 / 20,
    letterSpacing: 0,
    textBaseline: TextBaseline.alphabetic,
  );
}
