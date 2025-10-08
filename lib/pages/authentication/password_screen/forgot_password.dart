import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/email_inputfield.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.width20,
                ),
                child: Form(
                  key: controller.formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forgot Password',
                        style: bohibaTheme.textTheme.headlineLarge,
                      ),
                      Text(
                        'No worries, We will send OTP to reset you password mail.',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleSmall!.color,
                        ),
                      ),
                      EmailInputField(
                        hintText: 'Email',
                        controller: controller.emailController,
                      ),
                      PrimaryButton(
                        label: 'SEND OTP',
                        onPressed: () async {
                          int success = await controller.sendOtp();
                          if (success > 0) {
                            navigateState.pushNamed(
                              AppRoute.otpScreen,
                              arguments: {
                                "email": controller.emailController.text.trim(),
                                "nxtRoute": AppRoute.setPwd,
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
