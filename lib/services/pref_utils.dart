import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _preferences;
  PrefUtils() {
    SharedPreferences.getInstance().then(
      (value) => _preferences = value,
    );
  }

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    GlobalService.printHandler("SharedPrefernces Initialized");
  }

  Future<void> clearPreferencesData() async {
    final keyPrefItems = [token, showConnectDialog, roleKey, biometricKey];
    for (var key in keyPrefItems) {
      await _preferences!.remove(key);
    }
  }

  Future<void> toggleBiometric(bool value) async {
    await saveBool(biometricKey, value);
  }

  bool loadBiometricSetting() {
    return getBool(biometricKey);
  }

  // Legacy — kept for any callers that still use ThemeMode directly.
  static ThemeMode getAppThemeMode() {
    final stored = _preferences?.getString(themeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => ThemeMode.light,
    );
  }

  static String? getStoredThemeMode() =>
      _preferences?.getString(themeKey);

  static Future<void> setStoredThemeMode(String value) async =>
      await _preferences?.setString(themeKey, value);

  Future<void> setThemeData(String value) {
    return _preferences!.setString(themeKey, value);
  }

  String getThemeData() {
    try {
      return _preferences!.getString(themeKey)!;
    } catch (e) {
      return 'light';
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
  static const String themeKey = 'app_theme_mode';
  static const String darkStartHourKey = 'dark_start_hour';
  static const String darkStartMinuteKey = 'dark_start_minute';
  static const String darkEndHourKey = 'dark_end_hour';
  static const String darkEndMinuteKey = 'dark_end_minute';
  static const String biometricKey = 'biometric_enabled';
  static const String roleKey = 'user_role';
  static const String showConnectDialog = 'show_con_dialog';
  static const String keyFirebaseToken = 'firebase_token';
  static const String keyLat = 'key_lat';
  static const String keyLong = 'key_long';

  // Returns null when the user has never set a time-based schedule.
  static TimeOfDay? getDarkStartTime() {
    final h = _preferences?.getInt(darkStartHourKey);
    final m = _preferences?.getInt(darkStartMinuteKey);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  static TimeOfDay? getDarkEndTime() {
    final h = _preferences?.getInt(darkEndHourKey);
    final m = _preferences?.getInt(darkEndMinuteKey);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  Future<void> setDarkStartTime(TimeOfDay t) async {
    await _preferences!.setInt(darkStartHourKey, t.hour);
    await _preferences!.setInt(darkStartMinuteKey, t.minute);
  }

  Future<void> setDarkEndTime(TimeOfDay t) async {
    await _preferences!.setInt(darkEndHourKey, t.hour);
    await _preferences!.setInt(darkEndMinuteKey, t.minute);
  }

  Future<void> clearDarkSchedule() async {
    await _preferences?.remove(darkStartHourKey);
    await _preferences?.remove(darkStartMinuteKey);
    await _preferences?.remove(darkEndHourKey);
    await _preferences?.remove(darkEndMinuteKey);
  }

  static Future<void> setDarkStartTimeStatic(TimeOfDay t) async {
    await _preferences?.setInt(darkStartHourKey, t.hour);
    await _preferences?.setInt(darkStartMinuteKey, t.minute);
  }

  static Future<void> setDarkEndTimeStatic(TimeOfDay t) async {
    await _preferences?.setInt(darkEndHourKey, t.hour);
    await _preferences?.setInt(darkEndMinuteKey, t.minute);
  }

  static Future<void> clearDarkScheduleStatic() async {
    await _preferences?.remove(darkStartHourKey);
    await _preferences?.remove(darkStartMinuteKey);
    await _preferences?.remove(darkEndHourKey);
    await _preferences?.remove(darkEndMinuteKey);
  }
}
