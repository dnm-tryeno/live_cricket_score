import 'package:flutter/material.dart';

// TODO: Work with the designer to define clear, meaningful color names in Figma, and use consistent, readable names in code for better maintainability.
class AppColor {
  const AppColor({
    required this.black,
    required this.darkBlack,
    required this.darkGray,
    required this.lightPink,
    required this.lightYellow,
    required this.white,
    required this.lightMintGreen,
    required this.lightBlue,
    required this.lightGray,
    required this.veryLightGray,
    required this.offWhite,
    required this.pureWhite,
    required this.redColor,
    required this.darkBlueColor,
    required this.darkBlackColor,
    required this.purpleColor,
    required this.grayBlueColor,
    required this.whiteAndPurpleColor,
    required this.lightBlackColor,
    required this.divider,
    required this.transparentColor,
    required this.mediumGray,
    required this.greenColor,
    required this.lightGreenColor,
    required this.lightRedColor,
    required this.greyColor,
  });

  // Final Colors
  final Color transparentColor;
  final Color divider;
  final Color black;
  final Color darkBlack;
  final Color darkGray;
  final Color lightPink;
  final Color lightYellow;
  final Color white;
  final Color lightMintGreen;
  final Color lightBlue;
  final Color lightGray;
  final Color veryLightGray;
  final Color offWhite;
  final Color pureWhite;
  final Color redColor;
  final Color darkBlueColor;
  final Color darkBlackColor;
  final Color purpleColor;
  final Color grayBlueColor;
  final Color whiteAndPurpleColor;
  final Color lightBlackColor;
  final Color mediumGray;
  final Color greenColor;
  final Color lightGreenColor;
  final Color lightRedColor;
  final Color greyColor;

  // Static light colors
  static const lightColor = AppColor(
    lightBlackColor: Color(0x26000000),
    darkBlack: Color(0xFF333333),
    black: Color(0xFF000000),
    darkGray: Color(0xFF666666),
    lightPink: Color(0xFFFEE2E2),
    lightYellow: Color(0xFFFEF3C7),
    white: Color(0xFFFFFFFF),
    lightMintGreen: Color(0xFFD1FAE5),
    lightBlue: Color(0xFFE0F2FE),
    lightGray: Color(0xFFE4E4E7),
    veryLightGray: Color(0xFFE9E9E9),
    offWhite: Color(0xFFF3F4F6),
    pureWhite: Color(0xFFF6F6F6),
    transparentColor: Color(0x00000000),
    divider: Color(0xFFf4f6f6),
    purpleColor: Color(0xFF806FE0),
    darkBlackColor: Color(0xFF464857),
    whiteAndPurpleColor: Color(0xFFF8F6FC),
    grayBlueColor: Color(0xFFC7C8DB),
    darkBlueColor: Color(0xFF2A52BE),
    redColor: Color(0xFFA73E3E),
    mediumGray: Color(0xFF999999),
    greenColor: Color(0xFF4CAF50),
    lightGreenColor: Color(0xFF81C784),
    lightRedColor: Color(0xFFE57373),
    greyColor: Color(0xFFE0E0E0),
  );

  //Static dark color
  static const darkColor = AppColor(
    lightBlackColor: Color(0x26000000),
    black: Color(0xFF000000),
    darkBlack: Color(0xFF333333),
    darkGray: Color(0xFF666666),
    lightPink: Color(0xFFFEE2E2),
    lightYellow: Color(0xFFFEF3C7),
    white: Color(0xFFFFFFFF),
    lightMintGreen: Color(0xFFD1FAE5),
    lightBlue: Color(0xFFE0F2FE),
    lightGray: Color(0xFFE4E4E7),
    veryLightGray: Color(0xFFE9E9E9),
    offWhite: Color(0xFFF3F4F6),
    pureWhite: Color(0xFFF6F6F6),
    transparentColor: Color(0x00000000),
    divider: Color(0xFFf4f6f6),
    purpleColor: Color(0xFF1C8DCE),
    darkBlackColor: Color(0xFF464857),
    whiteAndPurpleColor: Color(0xFF3C3B3B),
    grayBlueColor: Color(0xFFC5C5C5),
    darkBlueColor: Color(0xFF2A52BE),
    redColor: Color(0xFFA73E3E),
    mediumGray: Color(0xFF999999),
    greenColor: Color(0xFF4CAF50),
    lightGreenColor: Color(0xFF81C784),
    lightRedColor: Color(0xFFE57373),
    greyColor: Color(0xFFE0E0E0),
  );

  Color get whiteColor => white;
  Color get blackColor => black;
  Color get grayColor => lightGray;
  Color get darkGrayColor => darkGray;
}

extension AppColorExtension on BuildContext {
  // get color set by brightness
  AppColor get color => _getColorByBrightness(Theme.of(this).brightness);
  // decide colors
  AppColor _getColorByBrightness(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        return AppColor.lightColor;
      case Brightness.dark:
        return AppColor.darkColor;
    }
  }
}
