import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  const PrimaryButton(
      {super.key,
      this.label = "Label",
      this.onPressed,
      this.width,
      this.height,
      this.color,
      this.padding,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: ScreenUtils.height5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width ?? ScreenUtils.width, height ?? 32.h),
          backgroundColor: color ?? bohibaTheme.colorScheme.primary,
          disabledBackgroundColor: color?.withValues(alpha: 0.25) ??
              bohibaTheme.colorScheme.onSurface,
        ),
        child: Text(
          label.toUpperCase(),
          style: textStyle ??
              TextStyle(
                fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                color: bohibaTheme.textTheme.displayLarge!.color,
              ),
        ),
      ),
    );
  }
}
