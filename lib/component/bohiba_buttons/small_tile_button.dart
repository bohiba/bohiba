import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:flutter/material.dart';

class SmallTileButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? label;
  const SmallTileButton({
    super.key,
    this.onTap,
    this.label = 'Label',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: bohibaColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: BohibaResponsiveScreen.width15,
              vertical: BohibaResponsiveScreen.height * 0.002),
          child: Text(
            label!,
            style: TextStyle(
              color: bohibaColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
