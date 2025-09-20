import 'package:flutter/material.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/email_inputfield.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordpagestate();
}

class _ForgotPasswordpagestate extends State<ForgotPasswordScreen> {
  // Controller
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Forgot',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'We will send verification mail.',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ),
                EmailInputField(hintText: 'Email', controller: emailController),
                PrimaryButton(
                  label: 'SEND CODE',
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoute.otpScreen);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
