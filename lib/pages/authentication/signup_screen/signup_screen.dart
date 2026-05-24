import 'package:bohiba/dist/enums/otp_purpose.dart';

import '../../../dist/enums/app_enums.dart';
import '/services/global_service.dart';
import 'package:flutter/services.dart';

import '/controllers/signup_controller.dart';
import '/dist/component_exports.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/theme/bohiba_theme.dart';
import '/component/bohiba_inputfield/email_inputfield.dart';
import '/routes/app_route.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navState = Navigator.of(context);
    return Obx(() {
      return Scaffold(
        appBar: null,
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop == true) {
              return;
            } else {
              GlobalService.showAlertDialog(
                status: AlertStatus.warning,
                title: 'EXIT',
                description: 'This will close the application. Do you want to continue?',
                discardBtnTxt: 'No',
                saveBtnTxt: 'Yes',
                onSave: () {
                  navState.pop();
                  SystemNavigator.pop();
                },
              );
            }
          },
          child: SafeArea(
            child: Container(
              height: ScreenUtils.height,
              width: ScreenUtils.width,
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.width20,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hello!',
                            style: bohibaTheme.textTheme.displayMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Let\'s begin the journey',
                            style: TextStyle(
                              fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                              fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleLarge!.color,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Form(
                              key: controller.signUpFormKey,
                              child: EmailInputField(
                                hintText: 'Email',
                                controller: controller.emailController,
                              ),
                            ),
                            SizedBox(height: ScreenUtils.height10),
                            PrimaryButton(
                              label: 'Verify',
                              onPressed: controller.isDisabled.value
                                  ? null
                                  : () async {
                                      String strEmail = controller.emailController.text.trim().toLowerCase();
                                      int verified = await controller.verifyEmail(
                                        email: strEmail,
                                      );
                                      if (verified > 0) {
                                        navState.pushNamed(
                                          AppRoute.otpScreen,
                                          arguments: {
                                            "email": strEmail,
                                            "otpPurpose": OtpPurpose.createUser,
                                          },
                                        );
                                      }
                                    },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: ScreenUtils.height30,
                    margin: EdgeInsets.symmetric(vertical: ScreenUtils.height20),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Already have account?',
                          style: bohibaTheme.textTheme.titleSmall,
                        ),
                        TextButton(
                          onPressed: () {
                            navState.popAndPushNamed(AppRoute.signIn);
                          },
                          child: Text(
                            'Signin',
                            style: TextStyle(
                              fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                              fontWeight: bohibaTheme.textTheme.headlineMedium!.fontWeight,
                              color: bohibaTheme.textTheme.bodySmall!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
