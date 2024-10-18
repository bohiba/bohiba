import 'package:bohiba/pages/authentication/otp_screen/otp_screen.dart';
import 'package:flutter/material.dart';

import '../../../utils/bohiba_buttons/primary_button.dart';
import '../../../utils/bohiba_inputfield/email_inputfield.dart';
import '../../../utils/bohiba_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

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
                            fontSize: 12,
                            letterSpacing: 0.5,
                            color: bohibaColors.secoundaryColor),
                      ),
                    ],
                  ),
                ),
                EmailInputField(hintText: 'Email', controller: emailController),
                PrimaryButton(
                  label: 'SEND CODE',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpScreen(
                                  email: emailController.text,
                                )));
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
