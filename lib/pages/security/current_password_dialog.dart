import 'package:bohiba/dist/enums/otp_purpose.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/dist/enums/app_enums.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import '/controllers/security_controller.dart';
import '/component/bohiba_inputfield/password_inputfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentPasswordDialog extends GetView<SecurityController> {
  const CurrentPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigateState = Navigator.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtils.height15,
        right: ScreenUtils.height15,
        top: ScreenUtils.height20,
        bottom: MediaQuery.paddingOf(context).bottom,
      ),
      child: Form(
        key: controller.formState,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Current Password',
                style: bohibaTheme.textTheme.displaySmall,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Please enter your current password to access this feature",
                style: bohibaTheme.textTheme.titleMedium,
              ),
            ),
            PasswordInputField(
              hintText: 'Password',
              nextActionType: TextInputAction.done,
              controller: controller.pwdController,
            ),
            PrimaryButton(
              padding: EdgeInsets.only(top: 15.h),
              label: 'Verify',
              onPressed: () {
                if (controller.pwdController.text.isEmpty ||
                    controller.pwdController.text.length <= 6) {
                  GlobalService.showSnackBar(
                    status: AlertStatus.info,
                    title: 'Security',
                    desc: 'Please enter valid password',
                  );
                  return;
                }
                navigateState.popAndPushNamed(
                  AppRoute.changePwd,
                  arguments: {
                    "current_password": controller.pwdController.text,
                    "otpPurpose": OtpPurpose.resetPassword,
                  },
                );
                controller.pwdController.clear();
              },
            )
          ],
        ),
      ),
    );
  }
}
