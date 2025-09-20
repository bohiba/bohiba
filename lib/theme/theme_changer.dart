import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const _themeModeKey = "theme_mode";

  /// Observable ThemeMode
  var themeMode = ThemeMode.system.obs;

  /// 🔹 Helper: check if currently dark mode
  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  /// Load saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeModeKey);

    if (saved != null) {
      themeMode.value = _stringToThemeMode(saved);
    } else {
      themeMode.value = _stringToThemeMode("light");
    }
  }

  /// Change theme mode and persist it
  Future<void> changeTheme(ThemeMode mode) async {
    themeMode.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _themeModeToString(mode));
    Get.forceAppUpdate();
  }

  /// 🔹 Toggle between dark and light only
  void toggleTheme() {
    if (isDarkMode) {
      changeTheme(ThemeMode.light);
    } else {
      changeTheme(ThemeMode.dark);
    }

    Get.forceAppUpdate();
  }

  /// Helpers
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return "dark";
      case ThemeMode.light:
        return "light";
      case ThemeMode.system:
        return "system";
    }
  }

  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case "dark":
        return ThemeMode.dark;
      case "light":
        return ThemeMode.light;
      case "system":
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
