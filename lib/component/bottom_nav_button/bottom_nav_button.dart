import 'package:bohiba/dist/component_exports.dart';
import 'package:flutter/material.dart';

import '../../theme/light_theme.dart';

class BottomNavButton extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final VoidCallback? onPressed;

  const BottomNavButton({
    super.key,
    this.onPressed,
    this.height = 47,
    this.width = 210,
    this.label = "Button",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: BohibaResponsiveScreen.height15,
        right: BohibaResponsiveScreen.height15,
        bottom: BohibaResponsiveScreen.height25,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: bohibaColors.primaryColor,
            fixedSize: Size(width, height)),
        child: Text(
          label,
          style: TextStyle(
              fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
              color: bohibaColors.white),
        ),
      ),
    );
  }
}
