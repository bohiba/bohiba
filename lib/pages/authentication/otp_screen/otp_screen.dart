import 'package:bohiba/dist/enums/otp_purpose.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '/controllers/otp_controller.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/dist/component_exports.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigateState = Navigator.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (result == true) {
          WidgetsBinding.instance.addPersistentFrameCallback((duration) {
            navigateState.pop(true);
          });
        }
      },
      child: Scaffold(
        appBar: null,
        body: Obx(() {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.width20,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Verify PIN',
                        style: TextStyle(
                          fontSize:
                              bohibaTheme.textTheme.displayMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.displayMedium!.fontWeight,
                          color: bohibaTheme.textTheme.displayMedium!.color,
                        ),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Text(
                              'Enter 6 digit code you have received in ',
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodyMedium!.fontSize,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.titleLarge!.color,
                              ),
                            ),
                          ),
                          WidgetSpan(
                            child: Text(
                              controller.email.value,
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodySmall!.fontSize,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.bodySmall!.color,
                              ),
                            ),
                          ),
                          WidgetSpan(child: SizedBox(width: 10)),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                controller.stopTimer();
                                navigateState.pop(true);
                              },
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: bohibaTheme
                                      .textTheme.bodyMedium!.fontSize,
                                  fontWeight: bohibaTheme
                                      .textTheme.bodyMedium!.fontWeight,
                                  color: bohibaTheme.textTheme.bodySmall!.color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(ScreenUtils.height10),
                    Form(
                      key: controller.otpFormKey,
                      child: PinCodeTextField(
                        controller: controller.otpController,
                        autoDisposeControllers: false,
                        appContext: context,
                        length: 6,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null && value!.isEmpty) {
                            return 'Please enter the OTP';
                          } else if (value.length != 6) {
                            return 'Please enter valid OTP';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.none,
                        animationDuration: Duration(milliseconds: 50),
                        textStyle: bohibaTheme.textTheme.bodyLarge,
                        pinTheme: PinTheme(
                          borderRadius: BorderRadius.circular(8.0),
                          shape: PinCodeFieldShape.box,
                          fieldWidth: 50,
                          activeColor: bohibaTheme.inputDecorationTheme
                              .enabledBorder?.borderSide.color,
                          disabledColor: bohibaTheme.inputDecorationTheme
                              .disabledBorder?.borderSide.color,
                          selectedFillColor: bohibaTheme.inputDecorationTheme
                              .enabledBorder?.borderSide.color,
                          inactiveColor: bohibaTheme.inputDecorationTheme
                              .enabledBorder?.borderSide.color,
                          activeFillColor: bohibaTheme.inputDecorationTheme
                              .enabledBorder?.borderSide.color,
                        ),
                      ),
                    ),
                    PrimaryButton(
                      label: 'Verify Code',
                      onPressed: () async {
                        switch (controller.otpPurpose) {
                          // case AppRoute.navBar:
                          //   navigateState.popAndPushNamed(AppRoute.navBar);
                          //   break;
                          // case AppRoute.signIn:
                          //   navigateState.popAndPushNamed(AppRoute.signIn);
                          case OtpPurpose.createUser:
                            int succesValidate = await controller.verifyOtp();
                            if (succesValidate > 0) {
                              navigateState.pushNamed(
                                AppRoute.createUser,
                                arguments: {
                                  'email': controller.email.value,
                                  'otpPurpose': OtpPurpose.createUser,
                                },
                              );
                            }
                            break;
                          case OtpPurpose.forgotPassword:
                            String? resetToken =
                                await controller.verifyForgotOtp();
                            if (resetToken != null) {
                              navigateState.pop();
                              navigateState.popAndPushNamed(
                                AppRoute.changePwd,
                                arguments: {
                                  'resetToken': resetToken,
                                  'otpPurpose': OtpPurpose.forgotPassword,
                                },
                                result: (route) {
                                  return false;
                                },
                              );
                            }
                            break;
                          case OtpPurpose.resetPassword:
                            // TODO: implement reset password API: /update-password
                            break;
                          default:
                            break;
                        }
                      },
                    )
                  ],
                ),
                Visibility(
                  visible: !controller.canResend,
                  child: Positioned(
                    bottom: ScreenUtils.height * 0.2,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Resend after ',
                        ),
                        Text(
                          '00:${controller.remainingSeconds.value.toString().padLeft(2, '0')} sec',
                          style: TextStyle(
                            fontWeight: bohibaTheme
                                .textTheme.headlineMedium!.fontWeight,
                            color: bohibaTheme.textTheme.titleLarge!.color,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: ScreenUtils.height55),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Didn\'t recieved OTP? ',
                        style: bohibaTheme.textTheme.titleSmall,
                      ),
                      InkWell(
                        onTap: controller.canResend == true
                            ? () async => await controller.resendOtp()
                            : null,
                        child: SizedBox(
                          child: Text(
                            ' Re-Send',
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.bodySmall!.fontSize,
                              fontWeight: bohibaTheme
                                  .textTheme.headlineMedium!.fontWeight,
                              color: controller.canResend == true
                                  ? bohibaTheme.textTheme.bodySmall!.color
                                  : bohibaTheme.disabledColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
