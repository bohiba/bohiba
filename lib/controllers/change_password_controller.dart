import '/dist/enums/api_status_code.dart';
import '/dist/enums/otp_purpose.dart';

import '/dist/enums/app_enums.dart';
import '/services/auth_service.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  TextEditingController cnfrmPwdController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  GlobalKey<FormState> setPwdState = GlobalKey<FormState>();

  String? currentPwd;
  String? resetToken;
  Rx<OtpPurpose> otpPurpose = OtpPurpose.none.obs;

  @override
  void onInit() {
    Map args = Get.arguments;
    currentPwd = args['current_password'];
    otpPurpose.value = args['otpPurpose'] ?? OtpPurpose.none;
    resetToken = args['resetToken'];
    super.onInit();
  }

  Future<StatusCode> handleOnSumbit() async {
    if (!setPwdState.currentState!.validate()) {
      return StatusCode.unprocessableEntity;
    }

    if (pwdController.text != cnfrmPwdController.text) {
      GlobalService.showSnackBar(
        status: AlertStatus.info,
        title: 'Security',
        desc: 'Password and Confirm Password must be same',
      );
      return StatusCode.unprocessableEntity;
    }

    if (currentPwd == cnfrmPwdController.text.trim()) {
      GlobalService.showSnackBar(
        status: AlertStatus.info,
        title: 'Security',
        desc: 'New Password should be similar to current password.',
      );
      return StatusCode.unprocessableEntity;
    }

    switch (otpPurpose.value) {
      case OtpPurpose.forgotPassword:
        return await forgotPassword();
      case OtpPurpose.resetPassword:
        return await changePassword();
      case OtpPurpose.none:
        GlobalService.showSnackBar(
          status: AlertStatus.info,
          title: 'Error',
          desc: 'Something went wrong. Please try again.',
        );
        return StatusCode.notImplemented;
      case OtpPurpose.createUser:
        return StatusCode.notImplemented;
    }
  }

  Future<StatusCode> forgotPassword() async {
    if (!setPwdState.currentState!.validate()) {
      return StatusCode.unprocessableEntity;
    }

    StatusCode success = await AuthService.resetPassword(
      bodyObj: {
        'password': pwdController.text.trim(),
        'token': resetToken,
      },
    );

    return success;
  }

  Future<StatusCode> changePassword() async {
    if (!setPwdState.currentState!.validate()) {
      return StatusCode.unprocessableEntity;
    }

    if (currentPwd == cnfrmPwdController.text) {
      GlobalService.showSnackBar(
        status: AlertStatus.info,
        title: 'Security',
        desc: 'New Password should be similar to current password.',
      );
      return StatusCode.unprocessableEntity;
    }

    StatusCode success = await AuthService.updatePassword(
      bodyObj: {
        'current_password': currentPwd,
        'new_password': pwdController.text.trim(),
      },
    );

    return success;
  }
}
