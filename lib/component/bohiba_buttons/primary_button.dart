import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';

import '../bohiba_colors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double width;
  final double height;

  const PrimaryButton({
    super.key,
    this.label = "Label",
    this.onPressed,
    this.width = double.maxFinite,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            fixedSize: Size(width, height),
            backgroundColor: bohibaColors.primaryColor),
        child: Text(
          label,
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
            fontWeight: bohibaTheme.textTheme.labelLarge!.fontWeight,
            color: bohibaColors.white,
          ),
        ),
      ),
    );
  }
}
