import 'package:bohiba/dist/enums/api_status_code.dart';

import '/services/global_service.dart';
import '/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  final RxBool isButtonEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();

    idController.addListener(listener);
    pwdController.addListener(listener);
  }

  Future<StatusCode> signin({
    required String uuid,
    required String password,
  }) async {
    GlobalService.closeKeyboard();
    // Use ?. to avoid crash if the form widget hasn't mounted yet.
    if (!(signInFormKey.currentState?.validate() ?? false)) {
      return StatusCode.unprocessableEntity;
    }
    final StatusCode result = await AuthService.signin(
      uuid: uuid,
      password: password,
    );
    if (result.isSuccess) {
      idController.clear();
      pwdController.clear();
    }
    return result;
  }

  String? validateUUIDField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your User ID';
    }
    return null;
  }

  void listener() {
    isButtonEnabled.value = idController.text.isNotEmpty &&
        idController.text.trim().length == 6 &&
        pwdController.text.isNotEmpty &&
        pwdController.text.length >= 4;
  }

  @override
  void onClose() {
    signInFormKey = GlobalKey<FormState>();
    idController.dispose();
    pwdController.dispose();
    isButtonEnabled.close();
    super.onClose();
  }
}
