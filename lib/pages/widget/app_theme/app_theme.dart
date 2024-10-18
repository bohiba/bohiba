import 'package:bohiba/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:get/get.dart';

import '../../../services/pref_utils.dart';

class ThemeHelper {
  final _appTheme = PrefUtils().getThemeData();

  final Map<String, BohibaColors> _supportedCustomColor = {
    'primary': BohibaColors()
  };

  final Map<String, ColorScheme> _supportBohibaColorScheme = {
    'primary': ColorSchemes.bohibaColorsScheme,
  };

  void changeTheme(String newTheme) {
    PrefUtils().setThemeData(newTheme);
    Get.forceAppUpdate();
  }

  BohibaColors _getThemeColors() {
    if (!_supportedCustomColor.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    return _supportedCustomColor[_appTheme] ?? BohibaColors();
  }

  ThemeData _getThemeData() {
    if (!_supportBohibaColorScheme.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    ColorScheme colorScheme =
        _supportBohibaColorScheme[_appTheme] ?? ColorSchemes.bohibaColorsScheme;
    return ThemeData(
      useMaterial3: false,
      splashColor: bohibaColors.primaryVariantColor,
      highlightColor: bohibaColors.primaryVariantColor,
      colorScheme: colorScheme,
      primaryIconTheme: IconThemeData(
        color: bohibaColors.primaryColor,
      ),
      primaryColor: bohibaColors.primaryColor,
      scaffoldBackgroundColor: bohibaColors.bgColor,
      fontFamily: 'Poppins',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: bohibaColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bohibaColors.bgColor,
        elevation: 0.25,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          color: bohibaColors.primaryColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          fontSize: 22.fontSize,
          // fontStyle: FontStyle.italic
        ),
        iconTheme: IconThemeData(
          color: bohibaColors.primaryColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: bohibaColors.primaryColor,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.fontSize,
          fontWeight: FontWeight.w700,
          color: bohibaColors.black,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.fontSize,
          letterSpacing: 1.5,
          color: bohibaColors.secoundaryColor,
          fontWeight: FontWeight.w500,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          color: bohibaColors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 12.fontSize,
        ),
        iconColor: bohibaColors.primaryColor,
        tileColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide.none,
        ),
      ),
      cardColor: Colors.grey.shade50,
      cardTheme: CardTheme(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.grey.shade50),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
          fontSize: 13.0.fontSize,
        ),
        prefixIconColor: bohibaColors.primaryColor,
        suffixIconColor: bohibaColors.primaryColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: bohibaColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: bohibaColors.primaryColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: bohibaColors.primaryColor,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.fontSize,
          fontWeight: FontWeight.w700,
          color: bohibaColors.black,
        ),
        displayMedium: TextStyle(
          fontSize: 28.fontSize,
          fontWeight: FontWeight.w700,
          color: bohibaColors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 26.fontSize,
          fontWeight: FontWeight.w700,
          color: bohibaColors.black,
        ),
        headlineLarge: TextStyle(
          fontSize: 22.fontSize,
          fontWeight: FontWeight.w700,
          color: bohibaColors.black,
        ),
        headlineMedium: TextStyle(
          fontSize: 18.fontSize,
          fontWeight: FontWeight.w600,
          color: bohibaColors.black,
        ),
        headlineSmall: TextStyle(
          fontSize: 16.fontSize,
          fontWeight: FontWeight.w600,
          color: bohibaColors.black,
        ),
        titleLarge: TextStyle(
          fontSize: 16.fontSize,
          letterSpacing: 1.5,
          color: Colors.grey.shade700,
        ),
        titleMedium: TextStyle(
          fontSize: 14.fontSize,
          letterSpacing: 1.7,
          color: Colors.grey.shade600,
        ),
        titleSmall: TextStyle(
          fontSize: 12.fontSize,
          color: Colors.grey.shade400,
        ),
        bodyLarge: const TextStyle(),
        bodyMedium: const TextStyle(),
        bodySmall: TextStyle(
          fontSize: 12.fontSize,
          fontWeight: FontWeight.w400,
          color: bohibaColors.primaryColor,
        ),
        labelLarge: TextStyle(
          color: bohibaColors.black,
          fontSize: 15.fontSize,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontSize: 12.fontSize,
          fontWeight: FontWeight.w600,
          color: bohibaColors.black,
        ),
        labelSmall: TextStyle(
          fontSize: 9.5.fontSize,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w700,
          color: bohibaColors.black,
        ),
      ),
    );
  }

  BohibaColors themeColor() => _getThemeColors();
  ThemeData themeData() => _getThemeData();
}

ThemeData get bohibaTheme => ThemeHelper().themeData();
