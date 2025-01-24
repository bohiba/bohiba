import 'package:flutter/material.dart';

ThemeData getDarkThemeData() {
  return ThemeData(
    brightness: Brightness.dark,
    buttonTheme: const ButtonThemeData(
        buttonColor: Colors.amber, disabledColor: Colors.black),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red),
  );
}
