import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/utils/bohiba_icon.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_inputfield/password_inputfield.dart';
import 'package:get/get.dart';
import '../../../utils/bohiba_buttons/primary_button.dart';
import '../../../utils/bohiba_inputfield/email_inputfield.dart';
import '../../../utils/bohiba_inputfield/text_inputfield.dart';
import '../../widget/app_theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool showPassword = true;
  bool loading = false;
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  final signupKey = GlobalKey<FormState>();

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    BohibaIcons.bohibaIcon,
                    height: BohibaResponsiveScreen.height50,
                  ),
                ),
                SizedBox(height: BohibaResponsiveScreen.height10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello!',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Let\'s begin the journey',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Form(
                  key: signupKey,
                  child: Column(
                    children: [
                      EmailInputField(
                        hintText: 'Email',
                        controller: emailController,
                      ),
                      TextInputField(
                        maxLength: 10,
                        controller: mobileController,
                        hintText: "Mobile Number",
                        keyboardType: TextInputType.number,
                      ),
                      PasswordInputField(
                        hintText: 'Password',
                        controller: pwdController,
                      )
                    ],
                  ),
                ),
                SizedBox(height: BohibaResponsiveScreen.height20),
                PrimaryButton(
                  label: 'SIGNUP',
                  onPressed: () => Get.toNamed(
                    BohibaRoute.userAuthScreen,
                    preventDuplicates: true,
                  ),
                )
              ]),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: BohibaResponsiveScreen.width8,
          vertical: BohibaResponsiveScreen.height8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have account? ',
              style: bohibaTheme.textTheme.titleSmall,
            ),
            InkWell(
              onTap: () => Get.offNamed(BohibaRoute.signIn),
              child: Container(
                height: BohibaResponsiveScreen.height30,
                width: BohibaResponsiveScreen.width50,
                alignment: Alignment.center,
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
    );
  }
}
