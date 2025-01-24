import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class DateInputField extends StatefulWidget {
  final VoidCallback? onTap;
  // final String? restorationId;
  final TextEditingController? controller;
  final String? hintText;
  const DateInputField({
    super.key,
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
      width: BohibaResponsiveScreen.width * 0.6,
      height: 47,
      margin: EdgeInsets.symmetric(
        vertical: BohibaResponsiveScreen.height5,
      ),
      child: TextFormField(
        readOnly: true,
        controller: widget.controller,
        onTap: widget.onTap,
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: widget.hintText,
          fillColor: bohibaColors.primaryColor,
          prefixIcon: Icon(
            EvaIcons.calendarOutline,
            color: bohibaColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
