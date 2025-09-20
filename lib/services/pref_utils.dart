import '/dist/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _preferences;
  PrefUtils() {
    SharedPreferences.getInstance().then(
      (value) => _preferences = value,
    );
  }

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    debugPrint(
        "\n================\n    SharedPrefernces Initialized     \n================\n");
  }

  void clearPreferencesData() async {
    _preferences!.clear();
  }

  Future<void> setAppThemeMode(AppThemeMode mode) async {
    await _preferences?.setString(_themeKey, mode.name);
  }

  AppThemeMode getAppThemeMode() {
    final stored = _preferences?.getString(_themeKey);
    return AppThemeMode.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => AppThemeMode.light,
    );
  }

  Future<void> setThemeData(String value) {
    return _preferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _preferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }

  Future<void> saveString(String key, String value) {
    return _preferences!.setString(key, value);
  }

  String getString(String key, {String defaultValue = ""}) {
    try {
      return _preferences!.getString(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  Future<void> saveInt(String key, int value) {
    return _preferences!.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    try {
      return _preferences!.getInt(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  Future<void> saveDouble(String key, double value) {
    return _preferences!.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    try {
      return _preferences!.getDouble(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  Future<void> saveBool(String key, bool value) {
    return _preferences!.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _preferences!.getBool(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  Future<void> remove(String key) async {
    await _preferences!.remove(key);
  }

  bool containsKey(String key) {
    return _preferences!.containsKey(key);
  }

  Set<String> getAllKeys() {
    return _preferences!.getKeys();
  }

  static const String token = 'app_token';
  static const String _themeKey = 'theme_mode';
}
