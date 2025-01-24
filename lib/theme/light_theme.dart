import 'package:bohiba/component/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:get/get.dart';

import '../services/pref_utils.dart';

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

  ThemeData _getThemeLightData() {
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
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: bohibaColors.bgColor, elevation: 0),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: bohibaColors.white,
        headerBackgroundColor: bohibaColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        headerHelpStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return bohibaColors.primaryColor;
          }
          return bohibaColors.white;
        }),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return bohibaColors.primaryColor;
          }
          return bohibaColors.white;
        }),
        todayBorder: BorderSide(
          width: 0.0,
          color: bohibaColors.primaryColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontSize: 16,
            color: bohibaColors.primaryColor,
          ),
          hintStyle: TextStyle(
            fontSize: 16,
            color: bohibaColors.primaryColor,
          ),
        ),
      ),
      colorScheme: colorScheme,
      primaryColor: bohibaColors.primaryColor,
      scaffoldBackgroundColor: bohibaColors.bgColor,
      cardColor: bohibaColors.tileColor,
      fontFamily: 'Poppins',
      tabBarTheme: TabBarTheme(
        labelColor: bohibaColors.primaryColor,
        unselectedLabelColor: bohibaColors.secoundaryColor,
        indicatorColor: bohibaColors.primaryColor,
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 0.4,
        color: bohibaColors.white,
        iconColor: bohibaColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          elevation: WidgetStatePropertyAll(0.4),
          backgroundColor: WidgetStatePropertyAll(bohibaColors.bgColor),
        ),
      ),
      primaryIconTheme: IconThemeData(
        color: bohibaColors.primaryColor,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.selected)) {
              return TextStyle(color: bohibaColors.primaryColor);
            }
            return TextStyle(color: bohibaColors.primaryColor);
          }),
        ),
      ),
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
          fontSize: 24.adaptSize,
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
          fontSize: 14.adaptSize,
          fontWeight: FontWeight.w700,
          color: bohibaColors.black,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.adaptSize,
          letterSpacing: 1.5,
          color: bohibaColors.secoundaryColor,
          fontWeight: FontWeight.w500,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          color: bohibaColors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 12.adaptSize,
        ),
        iconColor: bohibaColors.primaryColor,
        tileColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide.none,
        ),
      ),
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
          fontSize: 13.0.adaptSize,
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
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStatePropertyAll(bohibaColors.white),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return bohibaColors.primaryColor;
          }
          return bohibaColors.white;
        }),
        // overlayColor: WidgetStatePropertyAll(bohibaColors.warningColor)
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: bohibaColors.primaryColor,
        selectionColor: bohibaColors.primaryVariantColor,
        selectionHandleColor: bohibaColors.primaryVariantColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: bohibaColors.primaryColor,
        ),
      ),
      textTheme: _textTheme(),
    );
  }

  BohibaColors themeColor() => _getThemeColors();
  ThemeData themeData() => _getThemeLightData();
}

TextTheme _textTheme() {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32.adaptSize,
      fontWeight: FontWeight.w700,
      color: bohibaColors.black,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 28.adaptSize,
      fontWeight: FontWeight.w700,
      color: bohibaColors.black,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 26.adaptSize,
      fontWeight: FontWeight.w700,
      color: bohibaColors.black,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 22.adaptSize,
      fontWeight: FontWeight.w700,
      color: bohibaColors.black,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18.adaptSize,
      fontWeight: FontWeight.w600,
      color: bohibaColors.black,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.adaptSize,
      fontWeight: FontWeight.w600,
      color: bohibaColors.black,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.adaptSize,
      color: Colors.grey.shade700,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.adaptSize,
      color: const Color.fromARGB(255, 117, 117, 117),
    ),
    titleSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.adaptSize,
      color: const Color.fromRGBO(189, 189, 189, 1),
    ),
    bodyLarge: const TextStyle(
      fontFamily: 'Poppins',
    ),
    bodyMedium: const TextStyle(
      fontFamily: 'Poppins',
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.adaptSize,
      fontWeight: FontWeight.w400,
      color: bohibaColors.primaryColor,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      color: bohibaColors.black,
      fontSize: 15.adaptSize,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.adaptSize,
      fontWeight: FontWeight.w600,
      color: bohibaColors.black,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 9.5.adaptSize,
      letterSpacing: 1.0,
      fontWeight: FontWeight.w700,
      color: bohibaColors.black,
    ),
  );
}

ThemeData get bohibaTheme => ThemeHelper().themeData();
