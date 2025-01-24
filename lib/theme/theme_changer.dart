import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData = ThemeData(
    brightness: Brightness.dark,
    // primaryColor: Colors.amber,

    buttonTheme: const ButtonThemeData(
        buttonColor: Colors.amber, disabledColor: Colors.black),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red),
  );

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    _themeData = theme;

    notifyListeners();
  }
}
