import '/services/auth_service.dart';
import '/services/global_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController cnfrmPwdController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  GlobalKey<FormState> setPwdState = GlobalKey<FormState>();

  Future<int> sendOtp() async {
    GlobalService.closeKeyboard();
    if (!formState.currentState!.validate()) {
      return 0;
    }
    int success = await AuthService.emailOtp(
      email: emailController.text.toLowerCase(),
    );
    return success;
  }
}
