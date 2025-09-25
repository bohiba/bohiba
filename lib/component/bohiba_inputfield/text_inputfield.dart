import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputField extends StatelessWidget {
  final double? width;
  final double? height;
  final String? hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final TextInputAction? nextActionType;
  final Widget? prefixIcon;
  final String? counterText;

  const TextInputField({
    super.key,
    this.width,
    this.height,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.maxLines,
    this.maxLength,
    this.textCapitalization = TextCapitalization.words,
    this.onChanged,
    this.onEditingComplete,
    this.inputFormatters,
    this.readOnly = false,
    this.nextActionType,
    this.prefixIcon,
    this.counterText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? ScreenUtils.width,
      height: height ?? 47,
      margin: EdgeInsets.only(
        top: ScreenUtils.height5,
        bottom: ScreenUtils.height15,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        // expands: true,
        textInputAction: nextActionType,
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
          color: bohibaTheme.textTheme.bodyLarge!.color,
          letterSpacing: 1.2,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter Details';
          } else {
            return null;
          }
        },
        cursorColor: bohibaTheme.primaryColor,
        cursorRadius: Radius.circular(12.0.r),
        decoration: InputDecoration(
          hintText: hintText,
          counterText: counterText ?? "",
          prefixIcon: prefixIcon,
          // iconColor: BohibaColors.borderColor,
        ),
      ),
    );
  }
}
