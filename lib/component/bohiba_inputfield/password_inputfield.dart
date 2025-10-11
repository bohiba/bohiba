import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/component/bohiba_colors.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class PasswordInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputAction? nextActionType;

  const PasswordInputField(
      {super.key,
      required this.hintText,
      this.controller,
      this.nextActionType});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: TextFormField(
        controller: widget.controller,
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
          color: bohibaTheme.textTheme.bodyLarge!.color,
          letterSpacing: 1.2,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          } else {
            return null;
          }
        },
        cursorColor: bohibaTheme.primaryColor,
        cursorRadius: const Radius.circular(10.0),
        obscureText: showPassword,
        enableInteractiveSelection: false,
        textInputAction: widget.nextActionType,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(EvaIcons.lock),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            child: CircleAvatar(
              backgroundColor: BohibaColors.transparent,
              child: Icon(
                showPassword ? Remix.eye_close_line : Remix.eye_line,
                size: 16,
                color: bohibaTheme.primaryIconTheme.color,
              ),
            ),
          ),
          border: bohibaTheme.inputDecorationTheme.border,
          prefixIconColor: bohibaTheme.inputDecorationTheme.prefixIconColor,
          enabledBorder: bohibaTheme.inputDecorationTheme.enabledBorder,
          focusedBorder: bohibaTheme.inputDecorationTheme.focusedBorder,
          focusedErrorBorder:
              bohibaTheme.inputDecorationTheme.focusedErrorBorder,
          errorBorder: bohibaTheme.inputDecorationTheme.focusedErrorBorder,
        ),
      ),
    );
  }
}
