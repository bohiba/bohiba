import 'package:get/get.dart';

import '/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '/dist/component_exports.dart';
import '/routes/app_route.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/theme/bohiba_theme.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/password_inputfield.dart';

class SignInScreen extends GetView<AuthController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtils.getDimensions(context);
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(
          height: ScreenUtils.height,
          width: ScreenUtils.width,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.width20,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Glad to see you.',
                        style: bohibaTheme.textTheme.headlineLarge,
                      ),
                      Text(
                        'Login to get Started',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleSmall!.color,
                        ),
                      ),
                    ],
                  ),

                  // Login Form
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextInputField(
                        width: ScreenUtils.width,
                        hintText: 'User ID',
                        controller: controller.idController,
                        maxLength: 6,
                        textCapitalization: TextCapitalization.characters,
                        nextActionType: TextInputAction.next,
                        prefixIcon: Icon(
                          Icons.person_rounded,
                        ),
                      ),
                      PasswordInputField(
                        hintText: 'Password',
                        controller: controller.pwdController,
                        nextActionType: TextInputAction.done,
                      ),
                    ],
                  ),

                  //Recover Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.pushNamed(context, AppRoute.forgotScreen);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtils.height10,
                          ),
                          child: Text(
                            'Forgot UUID?',
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.titleMedium!.fontSize,
                              fontWeight: bohibaTheme
                                  .textTheme.headlineMedium!.fontWeight,
                              color: bohibaTheme.textTheme.bodySmall!.color,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoute.forgotScreen);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtils.height10,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.titleMedium!.fontSize,
                              fontWeight: bohibaTheme
                                  .textTheme.headlineMedium!.fontWeight,
                              color: bohibaTheme.textTheme.bodySmall!.color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  PrimaryButton(
                    label: 'Sign In',
                    onPressed: () async {
                      // Navigator.of(context).pushNamed(
                      //   AppRoute.navBar,
                      //   arguments: {
                      //     "current_index": 0,
                      //   },
                      // );

                      await controller.signin(
                        uuid: controller.idController.text.trim(),
                        password: controller.pwdController.text.trim(),
                      );
                    },
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(bottom: ScreenUtils.height47),
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have account ? ',
                      style: bohibaTheme.textTheme.titleSmall,
                    ),
                    InkWell(
                      onTap: () {
                        Get.offAndToNamed(AppRoute.signUp);
                      },
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.headlineMedium!.fontWeight,
                          color: bohibaTheme.textTheme.bodySmall!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
