// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i17;
import 'dart:typed_data' as _i15;

import 'package:auto_route/auto_route.dart' as _i13;
import 'package:collection/collection.dart' as _i19;
import 'package:flutter/foundation.dart' as _i14;
import 'package:flutter/material.dart' as _i16;
import 'package:flutter_project/feature/background_changer_screen.dart' as _i1;
import 'package:flutter_project/feature/editor_screen.dart' as _i3;
import 'package:flutter_project/feature/home_screen.dart' as _i4;
import 'package:flutter_project/feature/image_picker_screen.dart' as _i5;
import 'package:flutter_project/feature/loading_screen.dart' as _i6;
import 'package:flutter_project/feature/processing_screen.dart' as _i7;
import 'package:flutter_project/feature/result_screen.dart' as _i8;
import 'package:flutter_project/feature/save_screen.dart' as _i9;
import 'package:flutter_project/feature/settings_screen.dart' as _i10;
import 'package:flutter_project/feature/shared/utils/common_web_view.dart'
    as _i2;
import 'package:flutter_project/feature/splash_screen.dart' as _i11;
import 'package:flutter_project/feature/tutorial_screen.dart' as _i12;
import 'package:image_picker/image_picker.dart' as _i18;

/// generated route for
/// [_i1.BackgroundChangerPage]
class BackgroundChangerRoute
    extends _i13.PageRouteInfo<BackgroundChangerRouteArgs> {
  BackgroundChangerRoute({
    _i14.Key? key,
    required _i15.Uint8List processedImage,
    _i16.Color? initialColor,
    bool initialBlur = false,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         BackgroundChangerRoute.name,
         args: BackgroundChangerRouteArgs(
           key: key,
           processedImage: processedImage,
           initialColor: initialColor,
           initialBlur: initialBlur,
         ),
         initialChildren: children,
       );

  static const String name = 'BackgroundChangerRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BackgroundChangerRouteArgs>();
      return _i1.BackgroundChangerPage(
        key: args.key,
        processedImage: args.processedImage,
        initialColor: args.initialColor,
        initialBlur: args.initialBlur,
      );
    },
  );
}

class BackgroundChangerRouteArgs {
  const BackgroundChangerRouteArgs({
    this.key,
    required this.processedImage,
    this.initialColor,
    this.initialBlur = false,
  });

  final _i14.Key? key;

  final _i15.Uint8List processedImage;

  final _i16.Color? initialColor;

  final bool initialBlur;

  @override
  String toString() {
    return 'BackgroundChangerRouteArgs{key: $key, processedImage: $processedImage, initialColor: $initialColor, initialBlur: $initialBlur}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BackgroundChangerRouteArgs) return false;
    return key == other.key &&
        processedImage == other.processedImage &&
        initialColor == other.initialColor &&
        initialBlur == other.initialBlur;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      processedImage.hashCode ^
      initialColor.hashCode ^
      initialBlur.hashCode;
}

/// generated route for
/// [_i2.CommonWebViewPage]
class CommonWebViewRoute extends _i13.PageRouteInfo<CommonWebViewRouteArgs> {
  CommonWebViewRoute({
    _i16.Key? key,
    required String title,
    required String url,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         CommonWebViewRoute.name,
         args: CommonWebViewRouteArgs(key: key, title: title, url: url),
         initialChildren: children,
       );

  static const String name = 'CommonWebViewRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CommonWebViewRouteArgs>();
      return _i2.CommonWebViewPage(
        key: args.key,
        title: args.title,
        url: args.url,
      );
    },
  );
}

class CommonWebViewRouteArgs {
  const CommonWebViewRouteArgs({
    this.key,
    required this.title,
    required this.url,
  });

  final _i16.Key? key;

  final String title;

  final String url;

  @override
  String toString() {
    return 'CommonWebViewRouteArgs{key: $key, title: $title, url: $url}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CommonWebViewRouteArgs) return false;
    return key == other.key && title == other.title && url == other.url;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ url.hashCode;
}

/// generated route for
/// [_i3.EditorPage]
class EditorRoute extends _i13.PageRouteInfo<EditorRouteArgs> {
  EditorRoute({
    _i16.Key? key,
    required _i17.File originalImage,
    required _i15.Uint8List processedImage,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         EditorRoute.name,
         args: EditorRouteArgs(
           key: key,
           originalImage: originalImage,
           processedImage: processedImage,
         ),
         initialChildren: children,
       );

  static const String name = 'EditorRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditorRouteArgs>();
      return _i3.EditorPage(
        key: args.key,
        originalImage: args.originalImage,
        processedImage: args.processedImage,
      );
    },
  );
}

class EditorRouteArgs {
  const EditorRouteArgs({
    this.key,
    required this.originalImage,
    required this.processedImage,
  });

  final _i16.Key? key;

  final _i17.File originalImage;

  final _i15.Uint8List processedImage;

  @override
  String toString() {
    return 'EditorRouteArgs{key: $key, originalImage: $originalImage, processedImage: $processedImage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditorRouteArgs) return false;
    return key == other.key &&
        originalImage == other.originalImage &&
        processedImage == other.processedImage;
  }

  @override
  int get hashCode =>
      key.hashCode ^ originalImage.hashCode ^ processedImage.hashCode;
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i4.HomePage();
    },
  );
}

/// generated route for
/// [_i5.ImagePickerPage]
class ImagePickerRoute extends _i13.PageRouteInfo<ImagePickerRouteArgs> {
  ImagePickerRoute({
    _i16.Key? key,
    required _i18.ImageSource source,
    String? backgroundOption,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         ImagePickerRoute.name,
         args: ImagePickerRouteArgs(
           key: key,
           source: source,
           backgroundOption: backgroundOption,
         ),
         initialChildren: children,
       );

  static const String name = 'ImagePickerRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImagePickerRouteArgs>();
      return _i5.ImagePickerPage(
        key: args.key,
        source: args.source,
        backgroundOption: args.backgroundOption,
      );
    },
  );
}

class ImagePickerRouteArgs {
  const ImagePickerRouteArgs({
    this.key,
    required this.source,
    this.backgroundOption,
  });

  final _i16.Key? key;

  final _i18.ImageSource source;

  final String? backgroundOption;

  @override
  String toString() {
    return 'ImagePickerRouteArgs{key: $key, source: $source, backgroundOption: $backgroundOption}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImagePickerRouteArgs) return false;
    return key == other.key &&
        source == other.source &&
        backgroundOption == other.backgroundOption;
  }

  @override
  int get hashCode =>
      key.hashCode ^ source.hashCode ^ backgroundOption.hashCode;
}

/// generated route for
/// [_i6.LoadingPage]
class LoadingRoute extends _i13.PageRouteInfo<void> {
  const LoadingRoute({List<_i13.PageRouteInfo>? children})
    : super(LoadingRoute.name, initialChildren: children);

  static const String name = 'LoadingRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i6.LoadingPage();
    },
  );
}

/// generated route for
/// [_i7.ProcessingPage]
class ProcessingRoute extends _i13.PageRouteInfo<ProcessingRouteArgs> {
  ProcessingRoute({
    _i14.Key? key,
    required _i17.File imageFile,
    String? backgroundOption,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         ProcessingRoute.name,
         args: ProcessingRouteArgs(
           key: key,
           imageFile: imageFile,
           backgroundOption: backgroundOption,
         ),
         initialChildren: children,
       );

  static const String name = 'ProcessingRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProcessingRouteArgs>();
      return _i7.ProcessingPage(
        key: args.key,
        imageFile: args.imageFile,
        backgroundOption: args.backgroundOption,
      );
    },
  );
}

class ProcessingRouteArgs {
  const ProcessingRouteArgs({
    this.key,
    required this.imageFile,
    this.backgroundOption,
  });

  final _i14.Key? key;

  final _i17.File imageFile;

  final String? backgroundOption;

  @override
  String toString() {
    return 'ProcessingRouteArgs{key: $key, imageFile: $imageFile, backgroundOption: $backgroundOption}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProcessingRouteArgs) return false;
    return key == other.key &&
        imageFile == other.imageFile &&
        backgroundOption == other.backgroundOption;
  }

  @override
  int get hashCode =>
      key.hashCode ^ imageFile.hashCode ^ backgroundOption.hashCode;
}

/// generated route for
/// [_i8.ResultPage]
class ResultRoute extends _i13.PageRouteInfo<ResultRouteArgs> {
  ResultRoute({
    _i16.Key? key,
    required _i15.Uint8List processedImage,
    _i16.Color? backgroundColor,
    required String backgroundType,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         ResultRoute.name,
         args: ResultRouteArgs(
           key: key,
           processedImage: processedImage,
           backgroundColor: backgroundColor,
           backgroundType: backgroundType,
         ),
         initialChildren: children,
       );

  static const String name = 'ResultRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResultRouteArgs>();
      return _i8.ResultPage(
        key: args.key,
        processedImage: args.processedImage,
        backgroundColor: args.backgroundColor,
        backgroundType: args.backgroundType,
      );
    },
  );
}

class ResultRouteArgs {
  const ResultRouteArgs({
    this.key,
    required this.processedImage,
    this.backgroundColor,
    required this.backgroundType,
  });

  final _i16.Key? key;

  final _i15.Uint8List processedImage;

  final _i16.Color? backgroundColor;

  final String backgroundType;

  @override
  String toString() {
    return 'ResultRouteArgs{key: $key, processedImage: $processedImage, backgroundColor: $backgroundColor, backgroundType: $backgroundType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResultRouteArgs) return false;
    return key == other.key &&
        processedImage == other.processedImage &&
        backgroundColor == other.backgroundColor &&
        backgroundType == other.backgroundType;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      processedImage.hashCode ^
      backgroundColor.hashCode ^
      backgroundType.hashCode;
}

/// generated route for
/// [_i9.SavePage]
class SaveRoute extends _i13.PageRouteInfo<SaveRouteArgs> {
  SaveRoute({
    _i16.Key? key,
    required _i15.Uint8List processedImage,
    _i16.Color? backgroundColor,
    List<_i16.Color>? gradientColors,
    String? backgroundImage,
    _i15.Uint8List? customBackgroundImage,
    bool isBlurred = false,
    double scale = 1.0,
    _i16.Offset offset = _i16.Offset.zero,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         SaveRoute.name,
         args: SaveRouteArgs(
           key: key,
           processedImage: processedImage,
           backgroundColor: backgroundColor,
           gradientColors: gradientColors,
           backgroundImage: backgroundImage,
           customBackgroundImage: customBackgroundImage,
           isBlurred: isBlurred,
           scale: scale,
           offset: offset,
         ),
         initialChildren: children,
       );

  static const String name = 'SaveRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SaveRouteArgs>();
      return _i9.SavePage(
        key: args.key,
        processedImage: args.processedImage,
        backgroundColor: args.backgroundColor,
        gradientColors: args.gradientColors,
        backgroundImage: args.backgroundImage,
        customBackgroundImage: args.customBackgroundImage,
        isBlurred: args.isBlurred,
        scale: args.scale,
        offset: args.offset,
      );
    },
  );
}

class SaveRouteArgs {
  const SaveRouteArgs({
    this.key,
    required this.processedImage,
    this.backgroundColor,
    this.gradientColors,
    this.backgroundImage,
    this.customBackgroundImage,
    this.isBlurred = false,
    this.scale = 1.0,
    this.offset = _i16.Offset.zero,
  });

  final _i16.Key? key;

  final _i15.Uint8List processedImage;

  final _i16.Color? backgroundColor;

  final List<_i16.Color>? gradientColors;

  final String? backgroundImage;

  final _i15.Uint8List? customBackgroundImage;

  final bool isBlurred;

  final double scale;

  final _i16.Offset offset;

  @override
  String toString() {
    return 'SaveRouteArgs{key: $key, processedImage: $processedImage, backgroundColor: $backgroundColor, gradientColors: $gradientColors, backgroundImage: $backgroundImage, customBackgroundImage: $customBackgroundImage, isBlurred: $isBlurred, scale: $scale, offset: $offset}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SaveRouteArgs) return false;
    return key == other.key &&
        processedImage == other.processedImage &&
        backgroundColor == other.backgroundColor &&
        const _i19.ListEquality().equals(
          gradientColors,
          other.gradientColors,
        ) &&
        backgroundImage == other.backgroundImage &&
        customBackgroundImage == other.customBackgroundImage &&
        isBlurred == other.isBlurred &&
        scale == other.scale &&
        offset == other.offset;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      processedImage.hashCode ^
      backgroundColor.hashCode ^
      const _i19.ListEquality().hash(gradientColors) ^
      backgroundImage.hashCode ^
      customBackgroundImage.hashCode ^
      isBlurred.hashCode ^
      scale.hashCode ^
      offset.hashCode;
}

/// generated route for
/// [_i10.SettingsPage]
class SettingsRoute extends _i13.PageRouteInfo<void> {
  const SettingsRoute({List<_i13.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i10.SettingsPage();
    },
  );
}

/// generated route for
/// [_i11.SplashScreenPage]
class SplashScreenRoute extends _i13.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i13.PageRouteInfo>? children})
    : super(SplashScreenRoute.name, initialChildren: children);

  static const String name = 'SplashScreenRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i11.SplashScreenPage();
    },
  );
}

/// generated route for
/// [_i12.TutorialPage]
class TutorialRoute extends _i13.PageRouteInfo<void> {
  const TutorialRoute({List<_i13.PageRouteInfo>? children})
    : super(TutorialRoute.name, initialChildren: children);

  static const String name = 'TutorialRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i12.TutorialPage();
    },
  );
}
