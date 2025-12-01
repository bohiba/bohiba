import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class DateInputField extends StatefulWidget {
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? Function(String? inputValue)? validateField;
  final String? hintText;
  final bool showPrefixIcon;
  const DateInputField({
    super.key,
    this.width,
    this.height,
    this.onTap,
    this.controller,
    this.hintText,
    this.validateField,
    this.showPrefixIcon = true,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? ScreenUtils.width,
      // height: widget.height ?? 47,
      margin: EdgeInsets.only(
        bottom: ScreenUtils.height5,
      ),
      child: TextFormField(
        readOnly: true,
        controller: widget.controller,
        onTap: widget.onTap,
        onChanged: (value) {},
        validator: widget.validateField,
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
          color: bohibaTheme.textTheme.bodyLarge!.color,
          letterSpacing: 1.2,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: bohibaTheme.inputDecorationTheme.hintStyle,
          prefixIcon: widget.showPrefixIcon ? Icon(EvaIcons.calendarOutline) : null,
          border: bohibaTheme.inputDecorationTheme.border,
          prefixIconColor: bohibaTheme.inputDecorationTheme.prefixIconColor,
          enabledBorder: bohibaTheme.inputDecorationTheme.enabledBorder,
          focusedBorder: bohibaTheme.inputDecorationTheme.focusedBorder,
          focusedErrorBorder: bohibaTheme.inputDecorationTheme.focusedErrorBorder,
          errorBorder: bohibaTheme.inputDecorationTheme.focusedErrorBorder,
        ),
      ),
    );
  }
}
