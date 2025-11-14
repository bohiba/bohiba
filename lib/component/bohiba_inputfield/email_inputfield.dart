import 'package:get/get.dart';

import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;

  const EmailInputField({
    super.key,
    required this.hintText,
    this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtils.height10,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
          color: bohibaTheme.textTheme.bodyLarge!.color,
          letterSpacing: 1.0,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          } else if (!value.isEmail) {
            return 'Enter valid email address';
          } else {
            return null;
          }
        },
        cursorColor: BohibaColors.primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            Icons.email_rounded,
            color: BohibaColors.borderColor,
          ),
        ),
      ),
    );
  }
}
