import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

import '../bohiba_colors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double? width;
  final double? height;
  final Color? color;
  const PrimaryButton({
    super.key,
    this.label = "Label",
    this.onPressed,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtils.height5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(
              width ?? ScreenUtils.width * 0.9, height ?? ScreenUtils.height47),
          backgroundColor: color ?? BohibaColors.primaryColor,
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
            fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
            color: BohibaColors.white,
          ),
        ),
      ),
    );
  }
}
