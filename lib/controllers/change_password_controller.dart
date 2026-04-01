import '../dist/enums/app_enums.dart';
import '/services/auth_service.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  TextEditingController cnfrmPwdController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  GlobalKey<FormState> setPwdState = GlobalKey<FormState>();

  String? currentPwd;

  @override
  void onInit() {
    currentPwd = Get.arguments;
    super.onInit();
  }

  Future<int> changePassword() async {
    if (!setPwdState.currentState!.validate()) {
      return 0;
    }

    if (cnfrmPwdController.text != pwdController.text) {
      GlobalService.showSnackBar(
        status: AlertStatus.info,
        title: 'Security',
        desc: 'Password doesn`t match',
      );
      return 0;
    }

    if (currentPwd == cnfrmPwdController.text) {
      GlobalService.showSnackBar(
        status: AlertStatus.info,
        title: 'Security',
        desc: 'New Password should be similar to current password.',
      );
      return 0;
    }

    int success = await AuthService.changePassword(bodyObj: {'current_password': currentPwd, 'new_password': pwdController.text});

    return success;
  }
}
