import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/utils/bohiba_inputfield/text_inputfield.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/bohiba_buttons/primary_button.dart';
import '../../../utils/bohiba_inputfield/password_inputfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInpagestate();
}

class _SignInpagestate extends State<SignInScreen> {
  //TextField State
  bool showPassword = true;

  //Email and Password Controller
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: BohibaResponsiveScreen.height,
          width: BohibaResponsiveScreen.width,
          padding: EdgeInsets.symmetric(
            horizontal: BohibaResponsiveScreen.width20,
          ),
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
                      fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                      fontWeight: bohibaTheme.textTheme.titleSmall!.fontWeight,
                      color: bohibaTheme.textTheme.titleSmall!.color,
                    ),
                  ),
                ],
              ),

              // Login Form
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextInputField(
                      hintText: 'User ID',
                      controller: idController,
                      maxLength: 6,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    PasswordInputField(
                      hintText: 'Password',
                      controller: pwdController,
                    ),
                  ],
                ),
              ),

              //Recover Password
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Get.toNamed(BohibaRoute.forgotScreen),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: BohibaResponsiveScreen.height10,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.headlineMedium!.fontWeight,
                        color: bohibaTheme.textTheme.bodySmall!.color,
                      ),
                    ),
                  ),
                ),
              ),

              PrimaryButton(
                label: 'SIGN IN',
                onPressed: () => Get.toNamed(
                  BohibaRoute.navBar,
                  arguments: {
                    "current_index": 0,
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: BohibaResponsiveScreen.width8,
          vertical: BohibaResponsiveScreen.width10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have account ? ',
              style: bohibaTheme.textTheme.titleSmall,
            ),
            InkWell(
              onTap: () => {
                
                Get.offNamed(BohibaRoute.signUp)},
              child: Container(
                height: BohibaResponsiveScreen.height30,
                width: BohibaResponsiveScreen.width50,
                alignment: Alignment.center,
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
            ),
          ],
        ),
      ),
    );
  }
}
