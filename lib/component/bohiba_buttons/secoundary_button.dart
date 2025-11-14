import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class SecoundaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final TextStyle? textStyle;
  const SecoundaryButton({
    super.key,
    this.onPressed,
    this.label = 'Submit',
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? 120.w, height ?? 32.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ScreenUtils.width10,
          ),
          side: onPressed == null
              ? BorderSide.none
              : BorderSide(
                  color: color ?? bohibaTheme.primaryColor,
                  width: 1,
                ),
        ),
        backgroundColor: color ?? bohibaTheme.scaffoldBackgroundColor,
      ),
      child: Text(
        label.toUpperCase(),
        style: textStyle ??
            TextStyle(
              fontFamily: bohibaTheme.textTheme.labelLarge!.fontFamily,
              color: textColor ?? bohibaTheme.textTheme.bodySmall!.color,
              fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
            ),
      ),
    );
  }
}
