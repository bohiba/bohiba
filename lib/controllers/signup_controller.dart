import 'dart:async';

import '/services/auth_service.dart';
import '/services/global_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  // Bool
  RxBool isDisabled = false.obs;

  Future<int> verifyEmail({required String email}) async {
    GlobalService.closeKeyboard();
    if (!(signUpFormKey.currentState?.validate() ?? false)) {
      return 0;
    }
    // Disable the button for the duration of the API call to prevent
    // duplicate requests on slow networks.
    isDisabled.value = true;
    final int result = await AuthService.verifyEmail(txtEmail: email);
    isDisabled.value = false;
    return result;
  }

  @override
  void onClose() {
    signUpFormKey = GlobalKey<FormState>();
    emailController.dispose();
    isDisabled.value = false;
    super.onClose();
  }
}
