import '/dist/enums/api_status_code.dart';

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

  Future<StatusCode> sendOtp() async {
    GlobalService.closeKeyboard();
    if (!formState.currentState!.validate()) {
      return StatusCode.unprocessableEntity;
    }
    StatusCode success = await AuthService.emailOtp(
      email: emailController.text.toLowerCase().trim(),
    );
    return success;
  }
}
