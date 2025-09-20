import 'package:gap/gap.dart';

import '/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/dist/component_exports.dart';

/// It takes credential as arguments
class OtpScreen extends GetView<AuthController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigate = Navigator.of(context);
    String email = "";
    String nxtRoute = AppRoute.signIn;
    var route = Get.arguments;
    if (route == null) {
    } else {
      final Map<String, dynamic> argsObj = route as Map<String, dynamic>;
      email = argsObj['email'] ?? "";
      nxtRoute = argsObj["nxtRoute"] ?? "";
    }

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width20,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Verify PIN',
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.displayMedium!.fontSize,
                      fontWeight:
                          bohibaTheme.textTheme.displayMedium!.fontWeight,
                      color: bohibaTheme.textTheme.displayMedium!.color,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Enter 6 digit code you have received in ',
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodySmall!.fontSize,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.titleLarge!.color,
                              ),
                            ),
                            TextSpan(
                              text: "$email ",
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodySmall!.fontSize,
                                fontWeight: bohibaTheme
                                    .textTheme.bodyMedium!.fontWeight,
                                color: bohibaTheme.textTheme.titleLarge!.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        navigate.pop();
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodyMedium!.fontWeight,
                          color: bohibaTheme.textTheme.bodySmall!.color,
                        ),
                      ),
                    )
                  ],
                ),
                Gap(ScreenUtils.height30),
                PinCodeTextField(
                  controller: controller.otpController,
                  appContext: context,
                  length: 6,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  onChanged: (value) {},
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.none,
                  animationDuration: Duration(milliseconds: 50),
                  textStyle: bohibaTheme.textTheme.bodyLarge,
                  pinTheme: PinTheme(
                    borderRadius: BorderRadius.circular(8.0),
                    shape: PinCodeFieldShape.box,
                    fieldWidth: 50,
                    activeColor: BohibaColors.borderColor,
                    disabledColor: BohibaColors.borderColor,
                    selectedFillColor: BohibaColors.borderColor,
                    inactiveColor: BohibaColors.borderColor,
                    activeFillColor: BohibaColors.primaryColor,
                  ),
                ),
                SizedBox(height: ScreenUtils.height20),
                PrimaryButton(
                  label: 'Verify Code',
                  onPressed: () {
                    switch (nxtRoute) {
                      case AppRoute.navBar:
                        navigate.popAndPushNamed(AppRoute.navBar);
                        break;
                      case AppRoute.signIn:
                        navigate.popAndPushNamed(AppRoute.signIn);
                      case AppRoute.createUser:
                        controller.verifyOtp(
                          txtEmail: email,
                          txtOtp: controller.otpController.text.trim(),
                        );
                      // navigate.popAndPushNamed(AppRoute.createUser);
                      case AppRoute.setPwd:
                        navigate.popAndPushNamed(AppRoute.setPwd);
                      default:
                    }
                  },
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtils.height55),
              // color: Colors.amber,
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
                    onTap: () {
                      // Navigator.popAndPushNamed(context, AppRoute.signIn);
                    },
                    child: SizedBox(
                      // height: BohibaResponsiveScreen.height30,
                      // width: BohibaResponsiveScreen.width,
                      // alignment: Alignment.center,
                      child: Text(
                        ' Re-Send',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.headlineMedium!.fontWeight,
                          color: bohibaTheme.textTheme.bodySmall!.color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
