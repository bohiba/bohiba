import 'package:bohiba/model/profile_model.dart';

import '/routes/app_route.dart';

import '/dist/app_enums.dart';
import '/services/profile_service.dart';
import '/services/global_service.dart';
import '/services/main_service.dart';

import '/controllers/role_controller.dart';
import '/controllers/theme_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  // Controller
  final ThemeController themeController = Get.put(ThemeController());
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
      ProfileModel? profileModel =
          await ProfileService.getProfile(type: MethodType.api);
      if (profileModel != null) {
        roleId.value = RoleService.initRole(profileModel);
      }
      await MainService.mainApi(type: MethodType.api);
      Get.deleteAll();
      Get.put(() => ThemeController());
      Get.offAllNamed(AppRoute.navBar);
      GlobalService.showAppToast(message: 'Role Updated Successfully');
    }
  }

  Future<void> editProfile() async {}

  Future<void> enableNotification() async {}

  Future<void> enableEmailUpdate() async {}
}
