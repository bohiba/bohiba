import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const EmailInputField({super.key, required this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtils.height10,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
          color: bohibaTheme.textTheme.bodyLarge!.color,
          letterSpacing: 1.0,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter email';
          }
          final emailRegex = RegExp(
            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
          );
          if (!emailRegex.hasMatch(value.trim())) {
            return 'Enter a valid email address';
          }
          return null;
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
