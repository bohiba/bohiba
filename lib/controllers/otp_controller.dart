import 'dart:async';

import '/dist/enums/otp_purpose.dart';
import '/services/auth_service.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  TextEditingController otpController = TextEditingController();

  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  RxString email = "".obs;
  OtpPurpose otpPurpose = OtpPurpose.none;
  RxInt remainingSeconds = 0.obs;
  bool get canResend => remainingSeconds.value == 00;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    Map<String, dynamic>? route = Get.arguments;
    if (route != null) {
      final Map<String, dynamic> argsObj = route;
      email.value = argsObj['email'] ?? "";
      otpPurpose = argsObj["otpPurpose"] ?? OtpPurpose.none;
    }

    _startCountdown();
  }

  void stopTimer() {
    // Cancel first, then null — reversed order was a bug that let the timer
    // run forever because the reference was cleared before cancel() could fire.
    _timer?.cancel();
    _timer = null;
    remainingSeconds.value = 0;
  }

  Future<int> resendOtp() async {
    stopTimer();
    int success = await AuthService.resendOtp(email.value);
    if (success > 0) {
      _startCountdown();
    }
    return success;
  }

  Future<String?> verifyForgotOtp() async {
    GlobalService.closeKeyboard();

    if (!(otpFormKey.currentState!.validate())) {
      return null;
    }
    Map? result = await AuthService.verifyForgotOtp(
      txtEmail: email.value,
      txtOtp: otpController.text,
    );
    otpController.clear();

    if (result == null || !result.containsKey('reset_token')) return null;
    stopTimer();
    return result['reset_token'];
  }

  Future<String> verifyOtp() async {
    GlobalService.closeKeyboard();

    if (!(otpFormKey.currentState!.validate())) {
      return "FAILED";
    }
    String success = await AuthService.verifyOtp(
      txtEmail: email.value,
      txtOtp: otpController.text,
    );
    otpController.clear();
    if (success != 'SUCCESS') {
      stopTimer();
    }
    return success;
  }

  void _startCountdown() {
    stopTimer();
    remainingSeconds.value = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    otpController.dispose();
    stopTimer();
    super.onClose();
  }
}
