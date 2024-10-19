import 'package:flutter/material.dart';

class BohibaResponsiveScreen {
  static late double height;
  static late double height5;
  static late double height8;
  static late double height10;
  static late double height15;
  static late double height20;
  static late double height25;
  static late double height30;
  static late double height50;
  static late double height55;
  static late double height47;
  static late double width;
  static late double width5;
  static late double width8;
  static late double width10;
  static late double width15;
  static late double width20;
  static late double width25;
  static late double width50;

  static void getDimensions(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    height5 = 0.0054 * height;
    height8 = 0.0087 * height;
    height10 = 0.011 * height;
    height15 = 0.0164 * height;
    height20 = 0.021 * height;
    height25 = 0.0274 * height;
    height30 = 0.0383 * height;
    height47 = 0.051 * height;
    height50 = 0.0548 * height;
    height55 = 0.0822 * height;

    width = MediaQuery.sizeOf(context).width;
    width5 = 0.0115 * width;
    width8 = 0.0185 * width;
    width10 = 0.02314 * width;
    width15 = 0.0347 * width;
    width20 = 0.0462 * width;
    width25 = 0.0579 * width;
    width50 = 0.1159 * width;
  }
}

MediaQueryData mediaQuery = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.single);
num figmaDesignWidth = 390;
num figmaDesignHeight = 844;
num figmaStatusBar = 0;

extension ResponsiveExtension on num {
  get _width {
    return mediaQuery.size.width;
  }

  get _height {
    num statusBar = mediaQuery.viewPadding.top;
    num bottomBar = mediaQuery.viewPadding.bottom;
    num screenHeight = mediaQuery.size.height - statusBar - bottomBar;
    return screenHeight;
  }

  double get customWidth => ((this * _width) / figmaDesignWidth);
  double get customHeight => ((this * _height) / figmaDesignHeight);

  double get responsiveSize {
    double height = customHeight;
    double width = customWidth;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }

  double get fontSize => responsiveSize;
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}
