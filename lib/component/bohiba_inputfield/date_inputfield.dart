import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class DateInputField extends StatefulWidget {
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  // final String? restorationId;
  final TextEditingController? controller;
  final String? hintText;
  const DateInputField({
    super.key,
    this.width,
    this.height,
    this.onTap,
    // this.restorationId,
    this.controller,
    this.hintText,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? ScreenUtils.width * 0.95,
      height: widget.height ?? 47,
      margin: EdgeInsets.only(
        bottom: ScreenUtils.height10,
      ),
      child: TextFormField(
        readOnly: true,
        controller: widget.controller,
        onTap: widget.onTap,
        onChanged: (value) {},
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
          color: bohibaTheme.textTheme.bodyLarge!.color,
          letterSpacing: 1.2,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: bohibaTheme.inputDecorationTheme.hintStyle,
          // fillColor: BohibaColors.primaryColor,
          prefixIcon: Icon(
            EvaIcons.calendarOutline,
            // color: BohibaColors.borderColor,
          ),
        ),
      ),
    );
  }
}
