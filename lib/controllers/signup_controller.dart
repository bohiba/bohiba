import 'dart:async';

import '/services/auth_service.dart';
import '/services/global_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  // Int
  final RxInt secondsLeft = 0.obs;

  // Bool
  RxBool isDisabled = false.obs;

  // Timer
  Timer? _timer;

  Future<int> verifyEmail({required String email}) async {
    GlobalService.closeKeyboard();
    if (!(signUpFormKey.currentState!.validate())) {
      return 0;
    }
    int verfiedEmail = await AuthService.verifyEmail(txtEmail: email);

    if (verfiedEmail == 1) {
      startTimer();
    }
    return verfiedEmail;
  }

  void startTimer({int duration = 60}) {
    _timer?.cancel();
    secondsLeft.value = duration;
    isDisabled.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        isDisabled.value = false;
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  @override
  void dispose() {
    signUpFormKey = GlobalKey<FormState>();
    emailController.dispose();
    _timer?.cancel();
    secondsLeft.value = 0;
    isDisabled.value = false;
    super.dispose();
  }
}
