import '/controllers/auth_controller.dart';
import 'package:get/get.dart';
import '/component/bohiba_inputfield/email_inputfield.dart';
import 'package:flutter/material.dart';
import '/dist/component_exports.dart';
import '/routes/app_route.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/theme/bohiba_theme.dart';

class SignupScreen extends GetView<AuthController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        height: ScreenUtils.height,
        width: ScreenUtils.width,
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width20,
        ),
        child: Stack(
          children: [
            Column(
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
                    EmailInputField(
                      hintText: 'Email',
                      controller: controller.emailController,
                    ),
                    SizedBox(height: ScreenUtils.height10),
                    PrimaryButton(
                      label: 'Verify',
                      onPressed: () async {
                        await controller.verifyEmail(
                          email: controller.emailController.text
                              .trim()
                              .toLowerCase(),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtils.height47),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Already have account? ',
                    style: bohibaTheme.textTheme.titleSmall,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.popAndPushNamed(context, AppRoute.signIn);
                    },
                    child: SizedBox(
                      // height: BohibaResponsiveScreen.height30,
                      width: ScreenUtils.width50,
                      // alignment: Alignment.center,
                      child: Text(
                        'Signin',
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
