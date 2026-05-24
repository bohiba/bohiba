import 'package:bohiba/dist/enums/api_status_code.dart';
import 'package:bohiba/dist/enums/otp_purpose.dart';

import '/controllers/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/services/global_service.dart';
import '/component/bohiba_inputfield/password_inputfield.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/dist/component_exports.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Change Password',
      ),
      body: Container(
        height: ScreenUtils.height,
        width: ScreenUtils.width,
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Obx(() => Text(
                    controller.otpPurpose.value == OtpPurpose.forgotPassword
                        ? 'Set Password'
                        : 'Change Password',
                    style: bohibaTheme.textTheme.displayMedium,
                  )),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose a new password that is secure and easy to remember.",
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                  color: bohibaTheme.textTheme.titleLarge!.color,
                ),
              ),
            ),
            Form(
              key: controller.setPwdState,
              child: Column(
                children: [
                  PasswordInputField(
                    hintText: 'Password',
                    controller: controller.pwdController,
                    nextActionType: TextInputAction.next,
                  ),
                  PasswordInputField(
                    hintText: 'Confirm Password',
                    controller: controller.cnfrmPwdController,
                    nextActionType: TextInputAction.done,
                  ),
                ],
              ),
            ),
            // Gap(ScreenUtils.height10),
            PrimaryButton(
              label: 'Submit',
              onPressed: () async {
                GlobalService.closeKeyboard();

                StatusCode statusCode = await controller.handleOnSumbit();

                switch (controller.otpPurpose.value) {
                  case OtpPurpose.forgotPassword:
                    if (statusCode.isSuccess) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => navigateState.popUntil(
                          (route) => route.settings.name == AppRoute.signIn,
                        ),
                      );
                    }
                    break;
                  case OtpPurpose.resetPassword:
                    if (statusCode.isSuccess) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => navigateState.pop(true),
                      );
                    }
                    break;
                  case OtpPurpose.none:
                    break;
                  case OtpPurpose.createUser:
                    break;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
