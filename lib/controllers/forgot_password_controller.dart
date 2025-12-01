import '/model/profile_model.dart';
import '/services/profile_service.dart';

import '/services/auth_service.dart';
import '/services/global_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController cnfrmPwdController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getProfile();
    });
  }

  Future<void> getProfile() async {
    ProfileModel? profileModel = await ProfileService.getProfile();
    if (profileModel != null) {
      emailController.text = profileModel.email ?? '';
    }
  }

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
