import 'dart:async';

import '/routes/app_route.dart';
import '/services/auth_service.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  TextEditingController otpController = TextEditingController();

  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  RxString email = "".obs;
  String nxtRoute = AppRoute.signIn;
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
      nxtRoute = argsObj["nxtRoute"] ?? "";
    }

    _startCountdown();
  }

  void _cancelTimer() {
    if (_timer!.isActive) {
      _timer?.cancel();
    }
  }

  Future<int> resendOtp() async {
    _cancelTimer();
    int success = await AuthService.resendOtp(email.value);
    if (success > 0) {
      _startCountdown();
    }
    return success;
  }

  Future<int> verifyOtp() async {
    GlobalService.closeKeyboard();

    if (!(otpFormKey.currentState!.validate())) {
      return 0;
    }
    int success = await AuthService.verifyOtp(
      txtEmail: email.value,
      txtOtp: otpController.text,
    );
    otpController.clear();
    if (success != 1) {
      _cancelTimer();
    }
    return success;
  }

  void _startCountdown() {
    remainingSeconds.value = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    _cancelTimer();
    super.dispose();
  }
}
