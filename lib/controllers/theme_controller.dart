import 'dart:async';

import '/dist/enums/app_enums.dart';
import '/services/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // The effective Flutter ThemeMode fed to GetMaterialApp.
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  // Persisted user choice (default: light — first-launch shows light theme).
  final Rx<AppThemeMode> appThemeMode = AppThemeMode.light.obs;

  // Time-based schedule (null = not configured).
  final Rxn<TimeOfDay> darkStart = Rxn<TimeOfDay>();
  final Rxn<TimeOfDay> darkEnd = Rxn<TimeOfDay>();

  Timer? _timeCheckTimer;

  @override
  void onInit() {
    super.onInit();
    _loadFromPrefs();
  }

  void _loadFromPrefs() {
    final stored = PrefUtils.getStoredThemeMode();
    appThemeMode.value = _parseMode(stored);
    darkStart.value = PrefUtils.getDarkStartTime();
    darkEnd.value = PrefUtils.getDarkEndTime();
    _applyEffectiveTheme();

    if (appThemeMode.value == AppThemeMode.timeBased) {
      _startTimeCheckTimer();
    }
  }

  AppThemeMode _parseMode(String? s) {
    switch (s) {
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      case 'timeBased':
        return AppThemeMode.timeBased;
      case 'light':
      default:
        // null (first-launch) → light by default.
        return AppThemeMode.light;
    }
  }

  String _modeToString(AppThemeMode m) {
    switch (m) {
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
      case AppThemeMode.timeBased:
        return 'timeBased';
      case AppThemeMode.light:
        return 'light';
    }
  }

  void _applyEffectiveTheme() {
    switch (appThemeMode.value) {
      case AppThemeMode.light:
        themeMode.value = ThemeMode.light;
      case AppThemeMode.dark:
        themeMode.value = ThemeMode.dark;
      case AppThemeMode.system:
        themeMode.value = ThemeMode.system;
      case AppThemeMode.timeBased:
        themeMode.value = _isDarkBySchedule() ? ThemeMode.dark : ThemeMode.light;
    }
  }

  /// Returns true when current time falls inside the dark window.
  /// Handles overnight ranges (22:00 → 06:00).
  bool _isDarkBySchedule() {
    final start = darkStart.value;
    final end = darkEnd.value;
    if (start == null || end == null) return false;

    final now = TimeOfDay.now();
    final nowM = now.hour * 60 + now.minute;
    final startM = start.hour * 60 + start.minute;
    final endM = end.hour * 60 + end.minute;

    return startM <= endM
        ? nowM >= startM && nowM < endM          // same-day: 08:00–18:00
        : nowM >= startM || nowM < endM;          // overnight: 22:00–06:00
  }

  // Polls every minute — negligible battery cost vs. second-level tracking.
  void _startTimeCheckTimer() {
    _timeCheckTimer?.cancel();
    _timeCheckTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (appThemeMode.value == AppThemeMode.timeBased) {
        _applyEffectiveTheme();
      }
    });
  }

  void _stopTimeCheckTimer() {
    _timeCheckTimer?.cancel();
    _timeCheckTimer = null;
  }

  // --- Public API ---

  Future<void> changeMode(AppThemeMode mode) async {
    appThemeMode.value = mode;
    await PrefUtils.setStoredThemeMode(_modeToString(mode));
    if (mode == AppThemeMode.timeBased) {
      _startTimeCheckTimer();
    } else {
      _stopTimeCheckTimer();
    }
    _applyEffectiveTheme();
  }

  Future<void> saveSchedule({
    required TimeOfDay start,
    required TimeOfDay end,
  }) async {
    darkStart.value = start;
    darkEnd.value = end;
    await PrefUtils.setDarkStartTimeStatic(start);
    await PrefUtils.setDarkEndTimeStatic(end);
    if (appThemeMode.value == AppThemeMode.timeBased) {
      _applyEffectiveTheme();
    }
  }

  Future<void> clearSchedule() async {
    darkStart.value = null;
    darkEnd.value = null;
    await PrefUtils.clearDarkScheduleStatic();
    if (appThemeMode.value == AppThemeMode.timeBased) {
      _applyEffectiveTheme();
    }
  }

  @override
  void onClose() {
    _stopTimeCheckTimer();
    super.onClose();
  }
}
