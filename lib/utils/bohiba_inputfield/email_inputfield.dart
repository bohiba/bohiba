import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const EmailInputField({Key? key, required this.hintText, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: BohibaResponsiveScreen.height10,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: bohibaTheme.textTheme.bodyMedium,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter Email';
          } else {
            return null;
          }
        },
        cursorColor: bohibaColors.secoundaryColor,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}
