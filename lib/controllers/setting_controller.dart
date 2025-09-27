import '/routes/app_route.dart';
import '/services/global_service.dart';

import '/controllers/dashboard_controller.dart';
import '/controllers/master_controller.dart';
import '/dist/app_enums.dart';
import '/services/profile_service.dart';

import '/controllers/role_controller.dart';
import '/controllers/theme_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  // Controller
  final ThemeController themeController = Get.find<ThemeController>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final MasterController masterController = Get.find<MasterController>();
  Rx<int> roleId = 9.obs;

  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  RxString mode = 'System'.obs;

  // Bool
  RxBool notifications = false.obs;
  RxBool updates = false.obs;

  @override
  void onInit() {
    super.onInit();
    themeMode = themeController.themeMode;
    roleId.value = RoleService.roleId();
  }

  Future<void> switchProfile() async {
    Map<String, dynamic> bodyObj = {
      'role_id': roleId.value,
    };
    int updateRole = await ProfileService.setRole(bodyMap: bodyObj);
    if (updateRole > 0) {
      await dashboardController.getProfileModel(methodType: MethodType.server);
      await masterController.mainApi();
      Get.offAllNamed(AppRoute.navBar);
      GlobalService.showAppToast(message: 'Role Updated Successfully');
    }
  }

  Future<void> editProfile() async {}

  Future<void> enableNotification() async {}

  Future<void> enableEmailUpdate() async {}
}
