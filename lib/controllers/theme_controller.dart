import 'package:bohiba/services/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final PrefUtils prefUtils = PrefUtils();

  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  bool get isDarkMode => themeMode.value == ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      themeMode.value = PrefUtils.getAppThemeMode();
    });
  }

  Future<void> changeTheme(ThemeMode mode) async {
    themeMode.value = mode;
    await prefUtils.setThemeData(_themeModeToString(mode));
    Get.forceAppUpdate();
  }

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

  Future<void> resetTheme() async {
    themeMode.value = ThemeMode.light;
    await prefUtils.setThemeData(_themeModeToString(themeMode.value));
  }
}

// ThemeMode _stringToThemeMode(String value) {
//   switch (value) {
//     case "dark":
//       return ThemeMode.dark;
//     case "light":
//       return ThemeMode.light;
//     case "system":
//       return ThemeMode.system;
//     default:
//       return ThemeMode.light;
//   }
// }
