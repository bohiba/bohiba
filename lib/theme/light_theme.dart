import 'package:get/get.dart';

import '/component/screen_utils.dart';
import 'package:flutter/material.dart';
import '/component/bohiba_colors.dart';

import '../services/pref_utils.dart';

class ThemeHelper {
  final _appTheme = PrefUtils().getThemeData();

  final Map<String, BohibaColors> _supportedCustomColor = {
    'primary': BohibaColors()
  };

  final Map<String, ColorScheme> _supportBohibaColorScheme = {
    'primary': ColorSchemes.bohibaColorsScheme,
  };

  Future<void> changeTheme(String newTheme) async {
    PrefUtils().setThemeData(newTheme);
    await Get.forceAppUpdate();
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
      splashColor: BohibaColors.transparent,
      highlightColor: BohibaColors.primaryVariantColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: BohibaColors.bgColor,
        elevation: 10,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: BohibaColors.white,
        headerBackgroundColor: BohibaColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        headerHelpStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BohibaColors.primaryColor;
          }
          return BohibaColors.white;
        }),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BohibaColors.primaryColor;
          }
          return BohibaColors.white;
        }),
        todayBorder: BorderSide(
          width: 0,
          color: BohibaColors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontSize: 16,
            color: BohibaColors.primaryColor,
          ),
          hintStyle: TextStyle(
            fontSize: 12.adaptSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: BohibaColors.black,
          ),
        ),
      ),
      colorScheme: colorScheme,
      primaryColor: BohibaColors.primaryColor,
      scaffoldBackgroundColor: BohibaColors.bgColor,
      cardColor: BohibaColors.tileColor,
      fontFamily: 'Poppins',
      tabBarTheme: TabBarThemeData(
        labelColor: BohibaColors.primaryColor,
        unselectedLabelColor: BohibaColors.secoundaryColor,
        indicatorColor: BohibaColors.primaryColor,
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 5,
        color: BohibaColors.white,
        iconColor: BohibaColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          elevation: WidgetStatePropertyAll(0.4),
          backgroundColor: WidgetStatePropertyAll(BohibaColors.bgColor),
        ),
      ),
      primaryIconTheme: IconThemeData(
        color: BohibaColors.primaryColor,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.selected)) {
              return TextStyle(color: BohibaColors.primaryColor);
            }
            return TextStyle(color: BohibaColors.primaryColor);
          }),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: BohibaColors.primaryColor,
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
        backgroundColor: BohibaColors.bgColor,
        elevation: 0.25,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          color: BohibaColors.primaryColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          fontSize: 24.adaptSize,
          // fontStyle: FontStyle.italic
        ),
        iconTheme: IconThemeData(
          color: BohibaColors.primaryColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: BohibaColors.primaryColor,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.adaptSize,
          fontWeight: FontWeight.w700,
          color: BohibaColors.black,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.adaptSize,
          letterSpacing: 1.5,
          color: BohibaColors.secoundaryColor,
          fontWeight: FontWeight.w500,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          color: BohibaColors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 12.adaptSize,
        ),
        iconColor: BohibaColors.primaryColor,
        tileColor: BohibaColors.lightGreyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
          elevation: 1.5,
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
        prefixIconColor: BohibaColors.primaryColor,
        suffixIconColor: BohibaColors.primaryColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: BohibaColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: BohibaColors.borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: BohibaColors.warningColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: BohibaColors.primaryColor),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStatePropertyAll(BohibaColors.white),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BohibaColors.primaryColor;
          }
          return BohibaColors.white;
        }),
        // overlayColor: WidgetStatePropertyAll(BohibaColors.warningColor)
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (state) {
            if (state.contains(WidgetState.selected)) {
              return BohibaColors.primaryColor;
            }
            if (state.contains(WidgetState.disabled)) {
              return BohibaColors.lightGreyColor;
            }
            return BohibaColors.white;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (state) {
            if (state.contains(WidgetState.selected)) {
              return BohibaColors.borderColor;
            }
            if (state.contains(WidgetState.focused)) {
              return BohibaColors.white;
            }
            return BohibaColors.borderColor;
          },
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: BohibaColors.primaryColor,
        selectionColor: BohibaColors.primaryVariantColor,
        selectionHandleColor: BohibaColors.primaryVariantColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BohibaColors.primaryColor,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: BohibaColors.borderColor,
        color: BohibaColors.borderColor,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BohibaColors.primaryColor;
          }
          return BohibaColors.primaryColor;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BohibaColors.white;
          }
          return BohibaColors.primaryColor;
        }),
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
      color: BohibaColors.black,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 28.adaptSize,
      fontWeight: FontWeight.w700,
      color: BohibaColors.black,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 26.adaptSize,
      fontWeight: FontWeight.w700,
      color: BohibaColors.black,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 22.adaptSize,
      fontWeight: FontWeight.w700,
      color: BohibaColors.black,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18.adaptSize,
      fontWeight: FontWeight.w600,
      color: BohibaColors.black,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.adaptSize,
      fontWeight: FontWeight.w600,
      color: BohibaColors.black,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.adaptSize,
      color: const Color.fromARGB(255, 132, 132, 132),
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
    bodyLarge: TextStyle(
      fontSize: 16.adaptSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: BohibaColors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.adaptSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: BohibaColors.black,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.adaptSize,
      fontWeight: FontWeight.w400,
      color: BohibaColors.primaryColor,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      color: BohibaColors.black,
      fontSize: 15.adaptSize,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.adaptSize,
      fontWeight: FontWeight.w600,
      color: BohibaColors.black,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 9.5.adaptSize,
      letterSpacing: 1.0,
      fontWeight: FontWeight.w700,
      color: BohibaColors.black,
    ),
  );
}

// ThemeData get bohibaTheme => ThemeHelper().themeData();
