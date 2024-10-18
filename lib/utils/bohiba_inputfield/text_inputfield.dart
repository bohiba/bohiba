import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputField extends StatelessWidget {
  final String? hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final Icon? prefixIcon;

  const TextInputField({
    Key? key,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.maxLength,
    this.textCapitalization = TextCapitalization.words,
    this.onChanged,
    this.onEditingComplete,
    this.inputFormatters,
    this.readOnly = false,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: BohibaResponsiveScreen.height5,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
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
        cursorColor: bohibaColors.primaryColor,
        cursorRadius: const Radius.circular(10.0),
        decoration: InputDecoration(
          hintText: hintText,
          counterText: "",
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
