import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bohiba/utils/bohiba_colors.dart';

class TextImageInputField extends StatelessWidget {
  final String? hintText;
  final int? maxLength;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const TextImageInputField({
    Key? key,
    this.hintText,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.controller,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyLarge,
        validator: validator,
        decoration: InputDecoration(
          counterText: "",
          hintText: hintText,
          suffixIconColor: bohibaColors.bgColor,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
