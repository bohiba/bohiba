import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class RequiredLabel extends StatelessWidget {
  final String label;
  final bool required;

  const RequiredLabel({
    super.key,
    required this.label,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0.h),
      child: RichText(
        text: TextSpan(
          text: label,
          style: bohibaTheme.textTheme.labelLarge,
          children: required
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
