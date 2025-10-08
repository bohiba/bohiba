import '/services/auth_service.dart';
import '/services/global_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  Future<int> verifyEmail({required String email}) async {
    GlobalService.closeKeyboard();
    if (!(signUpFormKey.currentState!.validate())) {
      return 0;
    }
    int verfiedEmail = await AuthService.verifyEmail(txtEmail: email);
    return verfiedEmail;
  }

  @override
  void dispose() {
    signUpFormKey = GlobalKey<FormState>();
    emailController.dispose();
    super.dispose();
  }
}
