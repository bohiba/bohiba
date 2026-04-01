import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class PrimaryFloatingButton extends StatelessWidget {
  final String label;
  final Object? heroTag;
  final VoidCallback onPressed;
  final TextStyle? textStyle;

  const PrimaryFloatingButton({
    super.key,
    this.heroTag,
    required this.label,
    required this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtils.width * 0.9,
      child: FloatingActionButton.extended(
        heroTag: heroTag,
        elevation: 0,
        onPressed: onPressed,
        backgroundColor: BohibaColors.primaryColor,
        label: Text(
          label,
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
