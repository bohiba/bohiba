import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class SecoundaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double width;
  final double height;
  final Color? color;
  final Color? textColor;
  const SecoundaryButton({
    super.key,
    this.onPressed,
    this.label = 'Submit',
    this.width = 120,
    this.height = 47,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
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
        style: TextStyle(
          fontFamily: bohibaTheme.textTheme.labelLarge!.fontFamily,
          color: textColor ?? bohibaTheme.textTheme.bodySmall!.color,
          fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
        ),
      ),
    );
  }
}
