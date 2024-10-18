import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class PasswordInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;

  const PasswordInputField({Key? key, required this.hintText, this.controller})
      : super(key: key);

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: widget.controller,
        style: bohibaTheme.textTheme.bodyMedium,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter Password';
          } else {
            return null;
          }
        },
        cursorColor: bohibaColors.primaryColor,
        cursorRadius: const Radius.circular(10.0),
        obscureText: showPassword,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            child: CircleAvatar(
              backgroundColor: bohibaColors.transparent,
              child: Icon(
                showPassword ? Remix.eye_close_line : Remix.eye_line,
                size: 16,
                color: bohibaTheme.primaryIconTheme.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
