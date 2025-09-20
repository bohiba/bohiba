import '/theme/theme_changer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  // Controller
  final ThemeController themeController = Get.find<ThemeController>();

  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  RxString mode = 'System'.obs;

  // Bool
  RxBool notifications = false.obs;
  RxBool updates = false.obs;

  @override
  void onInit() {
    super.onInit();
    themeMode = themeController.themeMode;
  }

  Future<void> editProfile() async {}

  Future<void> enableNotification() async {}

  Future<void> enableEmailUpdate() async {}
}
