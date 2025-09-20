import 'dart:io';

import '/extensions/bohiba_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:universal_html/html.dart' as uhtml;

class ScreenUtils {
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
  static late double height65;
  static late double height47;
  static late double width;
  static late double width5;
  static late double width8;
  static late double width10;
  static late double width15;
  static late double width20;
  static late double width25;
  static late double width40;
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
    height65 = 0.0972 * height;

    width = MediaQuery.sizeOf(context).width;
    width5 = 0.0115 * width;
    width8 = 0.0185 * width;
    width10 = 0.02314 * width;
    width15 = 0.0347 * width;
    width20 = 0.0462 * width;
    width25 = 0.0579 * width;
    width40 = 0.0931 * width;
    width50 = 0.1159 * width;
  }
}

// This functions are responsible to make UI responsive across all the mobile devices.

MediaQueryData mediaQuery = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.single);

// These are the Viewport values of your Figma Design.
// These are used in the code as a reference to create your UI Responsively.
num figmaDesignWidth = 390;
num figmaDesignHeight = 844;
num figmaDesignStatusBar = 0;

///This extension is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
extension ResponsiveExtension on num {
  ///This method is used to get device viewport width.
  get _width {
    return mediaQuery.size.width;
  }

  ///This method is used to get device viewport height.
  get _height {
    num statusBar = mediaQuery.viewPadding.top;
    num bottomBar = mediaQuery.viewPadding.bottom;
    num screenHeight = mediaQuery.size.height - statusBar - bottomBar;
    return screenHeight;
  }

  ///This method is used to set padding/margin (for the left and Right side) & width of the screen or widget according to the Viewport width.
  double get customWidth => ((this * _width) / figmaDesignWidth);

  ///This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
  double get customHeight =>
      (this * _height) / (figmaDesignHeight - figmaDesignStatusBar);

  ///This method is used to set smallest px in image height and width
  double get adaptSize {
    var height = customHeight;
    var width = customWidth;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }

  ///This method is used to set text font size according to Viewport
  double get fSize => adaptSize;
}

class DeviceType {
  bool isTabletOrPhone() {
    final String userAgent =
        uhtml.window.navigator.userAgent.toString().toLowerCase();
    if (kIsWeb) {
      if (userAgent.contains("iphone") || userAgent.contains("android")) {
        return true;
      } else {
        return false;
      }
    } else {
      if (Platform.isAndroid) {
        final data = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first);

        return (data.size.shortestSide < 600);
      } else {
        return (!Device.get().isTablet);
      }
    }
  }
}
