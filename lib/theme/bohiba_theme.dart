import '/dist/app_enums.dart';
import '/services/pref_utils.dart';
import 'package:flutter/material.dart';
import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';

class BohibaTheme {
  final _appTheme = PrefUtils().getAppThemeMode();

  ThemeData themeData() {
    if (_appTheme == AppThemeMode.dark) {
      return darkTheme;
    } else if (_appTheme == AppThemeMode.light) {
      return lightTheme;
    } else {
      return lightTheme;
    }
  }

  static ThemeData get lightTheme => _lightTheme();
  static ThemeData get darkTheme => _darkTheme();

  /// Light Theme
  static ThemeData _lightTheme() {
    return ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        scaffoldBackgroundColor: BohibaColors.bgColor,
        splashColor: BohibaColors.primaryVariantColor,
        highlightColor: BohibaColors.primaryVariantColor,
        disabledColor: BohibaColors.primaryVariantColor,
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
        colorScheme: ColorScheme.light(
          primary: BohibaColors.primaryColor,
          secondary: BohibaColors.secoundaryColor,
          surface: BohibaColors.errorColor,
          onSurface: BohibaColors.successColor,
          error: BohibaColors.warningColor,
        ),
        primaryColor: BohibaColors.primaryColor,
        cardColor: BohibaColors.lightGreyColor,
        dividerColor: BohibaColors.lightGreyColor,
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
            iconColor: BohibaColors.white,
            backgroundColor: BohibaColors.primaryColor,
            disabledBackgroundColor: BohibaColors.primaryVariantColor,
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
          foregroundColor: BohibaColors.bgColor,
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
            color: BohibaColors.white,
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
        textTheme: lightTextTheme(),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: BohibaColors.bgColor,
        ),
        dividerTheme:
            DividerThemeData(thickness: 0.12, color: BohibaColors.greyColor),
        searchBarTheme: SearchBarThemeData(
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(BohibaColors.primaryColor),
        ),
        searchViewTheme: SearchViewThemeData());
  }

  static ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DarkColors.black,
      splashColor: BohibaColors.primaryVariantColor,
      highlightColor: BohibaColors.primaryVariantColor,
      disabledColor: BohibaColors.primaryVariantColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DarkColors.black,
        foregroundColor: DarkColors.black,
        elevation: 0.25,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          color: DarkColors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          fontSize: 24.adaptSize,
        ),
        iconTheme: IconThemeData(
          color: DarkColors.primaryColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: DarkColors.primaryColor,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.adaptSize,
          fontWeight: FontWeight.w700,
          color: DarkColors.secoundaryColor,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.adaptSize,
          letterSpacing: 1.5,
          color: DarkColors.secoundaryColor,
          fontWeight: FontWeight.w500,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          color: DarkColors.white,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 12.adaptSize,
        ),
        iconColor: DarkColors.primaryColor,
        tileColor: DarkColors.tileColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide.none,
        ),
      ),
      textTheme: darkTextTheme(),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DarkColors.black,
        elevation: 10,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: DarkColors.tileColor,
        headerBackgroundColor: DarkColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        headerHelpStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: DarkColors.white,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return DarkColors.primaryColor;
          }
          return DarkColors.tileColor;
        }),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return DarkColors.primaryColor;
          }
          return DarkColors.tileColor;
        }),
        todayBorder: BorderSide(
          width: 0,
          color: DarkColors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontSize: 16,
            color: DarkColors.primaryColor,
          ),
          hintStyle: TextStyle(
            fontSize: 12.adaptSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: DarkColors.greyColor,
          ),
        ),
      ),
      dividerColor: DarkColors.lightGreyColor,
      colorScheme: const ColorScheme.dark(
        primary: DarkColors.primaryColor,
        secondary: DarkColors.secoundaryColor,
        surface: DarkColors.black,
        onSurface: DarkColors.successColor,
        error: DarkColors.warningColor,
      ),
      primaryColor: DarkColors.primaryColor,
      cardColor: DarkColors.tileColor,
      fontFamily: 'Poppins',
      tabBarTheme: TabBarThemeData(
        labelColor: DarkColors.primaryColor,
        unselectedLabelColor: DarkColors.greyColor,
        indicatorColor: DarkColors.primaryColor,
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 5,
        color: DarkColors.tileColor,
        iconColor: DarkColors.primaryVariantColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          elevation: WidgetStatePropertyAll(0.4),
          backgroundColor: WidgetStatePropertyAll(DarkColors.tileColor),
        ),
      ),
      primaryIconTheme: IconThemeData(
        color: DarkColors.primaryColor,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            TextStyle(color: DarkColors.primaryVariantColor),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          iconColor: DarkColors.white,
          backgroundColor: DarkColors.primaryVariantColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          disabledBackgroundColor: DarkColors.primaryVariantColor,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: DarkColors.tileColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: DarkColors.greyColor,
          fontWeight: FontWeight.w400,
          fontSize: 13.0.adaptSize,
        ),
        prefixIconColor: DarkColors.primaryVariantColor,
        suffixIconColor: DarkColors.primaryVariantColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: DarkColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: DarkColors.primaryVariantColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: DarkColors.warningColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: DarkColors.primaryVariantColor),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStatePropertyAll(DarkColors.white),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return DarkColors.primaryVariantColor;
          }
          return DarkColors.tileColor;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (state) {
            if (state.contains(WidgetState.selected)) {
              return DarkColors.white;
            }
            return DarkColors.primaryColor;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (state) {
            if (state.contains(WidgetState.selected)) {
              return DarkColors.primaryColor;
            }
            return DarkColors.white;
          },
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: DarkColors.primaryColor,
        selectionColor: DarkColors.primaryColor,
        selectionHandleColor: DarkColors.primaryColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DarkColors.primaryVariantColor,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: DarkColors.borderColor,
        color: DarkColors.primaryVariantColor,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStatePropertyAll(DarkColors.primaryVariantColor),
        overlayColor:
            WidgetStatePropertyAll(DarkColors.white.withValues(alpha: 0.1)),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: DarkColors.black),
      dividerTheme: DividerThemeData(thickness: 1.0),
      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(BohibaColors.primaryColor),
      ),
    );
  }
}

ThemeData get bohibaTheme => BohibaTheme().themeData();

TextTheme lightTextTheme() {
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
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(255, 132, 132, 132),
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.adaptSize,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(255, 117, 117, 117),
    ),
    titleSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.adaptSize,
      fontWeight: FontWeight.w400,
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
      letterSpacing: 1.15,
      fontWeight: FontWeight.w500,
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

TextTheme darkTextTheme() {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32.adaptSize,
      fontWeight: FontWeight.w700,
      color: DarkColors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 28.adaptSize,
      fontWeight: FontWeight.w700,
      color: DarkColors.white,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 26.adaptSize,
      fontWeight: FontWeight.w700,
      color: DarkColors.white,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 22.adaptSize,
      fontWeight: FontWeight.w700,
      color: DarkColors.white,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18.adaptSize,
      fontWeight: FontWeight.w600,
      color: DarkColors.white,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.adaptSize,
      fontWeight: FontWeight.w600,
      color: DarkColors.white,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.adaptSize,
      fontWeight: FontWeight.w400,
      color: DarkColors.white,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.adaptSize,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(255, 180, 180, 180),
    ),
    titleSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.adaptSize,
      fontWeight: FontWeight.w400,
      color: const Color.fromRGBO(160, 160, 160, 1),
    ),
    bodyLarge: TextStyle(
      fontSize: 16.adaptSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: DarkColors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.adaptSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: DarkColors.white,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.adaptSize,
      fontWeight: FontWeight.w400,
      color: DarkColors.primaryColor, // accent
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      color: DarkColors.greyColor,
      fontSize: 15.adaptSize,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.adaptSize,
      letterSpacing: 1.15,
      fontWeight: FontWeight.w500,
      color: DarkColors.lightGreyColor,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 9.5.adaptSize,
      letterSpacing: 1.0,
      fontWeight: FontWeight.w700,
      color: DarkColors.white,
    ),
  );
}
