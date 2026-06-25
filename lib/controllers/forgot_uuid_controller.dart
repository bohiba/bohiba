import '/dist/enums/api_status_code.dart';
import '/extensions/bohiba_extension.dart';
import '/services/auth_service.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotUuidController extends GetxController {
  final TextEditingController panController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final isButtonEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateInputs);
    panController.addListener(_validateInputs);
  }

  void _validateInputs() {
    isButtonEnabled.value = emailController.text.trim().isEmail &&
        panController.text.trim().length == 10 &&
        panController.text.trim().isValidPan;
  }

  Future<bool?> forgotUUID() async {
    GlobalService.closeKeyboard();
    if (emailController.text.isEmpty) {
      return null;
    } else if (panController.text.isEmpty) {
      return null;
    }
    Map<String, String> requestData = {
      'email': emailController.text.trim().toLowerCase(),
      'pan_number': panController.text.trim().toUpperCase(),
    };
    StatusCode statusCode = await AuthService.forgotUUID(bodyObj: requestData);
    switch (statusCode) {
      case StatusCode.ok:
        emailController.clear();
        panController.clear();
        return true;
      default:
        return false;
    }
  }

  @override
  void onClose() {
    panController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
