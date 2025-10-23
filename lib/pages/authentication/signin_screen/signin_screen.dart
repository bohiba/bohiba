import '/dist/app_enums.dart';
import '/services/global_service.dart';

import '/controllers/auth_controller.dart';
import '/dist/component_exports.dart';
import '/routes/app_route.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/theme/bohiba_theme.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/password_inputfield.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInScreen extends GetView<AuthController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtils.getDimensions(context);
    final navigateState = Navigator.of(context);
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
              description:
                  'This will close the application. Do you want to continue?',
              discardBtnTxt: 'No',
              saveBtnTxt: 'Yes',
              onSave: () {
                navigateState.pop();
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
                              fontSize:
                                  bohibaTheme.textTheme.bodySmall!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleSmall!.color,
                            ),
                          ),
                        ],
                      ),

                      // Login Form
                      Form(
                        key: controller.signInFormKey,
                        child: Column(
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
                                color: bohibaTheme
                                    .inputDecorationTheme.prefixIconColor,
                              ),
                              validateField: (field) {
                                return controller.validateUUIDField(field);
                              },
                            ),
                            PasswordInputField(
                              hintText: 'Password',
                              controller: controller.pwdController,
                              nextActionType: TextInputAction.done,
                            ),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              navigateState.pushNamed(AppRoute.forgotUuid);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height10,
                              ),
                              child: Text(
                                'Forgot UUID?',
                                style: TextStyle(
                                  fontSize: bohibaTheme
                                      .textTheme.titleMedium!.fontSize,
                                  fontWeight: bohibaTheme
                                      .textTheme.headlineMedium!.fontWeight,
                                  color: bohibaTheme.textTheme.bodySmall!.color,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              navigateState.pushNamed(AppRoute.forgotPwd);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height10,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: bohibaTheme
                                      .textTheme.titleMedium!.fontSize,
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

                          int successLogin = await controller.signin(
                            uuid: controller.idController.text.trim(),
                            password: controller.pwdController.text.trim(),
                          );

                          if (successLogin > 0) {
                            navigateState.pushNamedAndRemoveUntil(
                              AppRoute.welcome,
                              ModalRoute.withName(AppRoute.welcome),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtils.height30,
                  margin: EdgeInsets.symmetric(vertical: ScreenUtils.height20),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have account ? ',
                        style: bohibaTheme.textTheme.titleSmall,
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateState.popAndPushNamed(AppRoute.signUp);
                        },
                        child: Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                            fontWeight: bohibaTheme
                                .textTheme.headlineMedium!.fontWeight,
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
      ),
    );
  }
}
