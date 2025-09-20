import 'package:bohiba/component/screen_utils.dart';

import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

import '../bohiba_colors.dart';

class PrimaryTextIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? widget;
  final String label;
  final double? width;
  final double? height;
  final Color? color;

  const PrimaryTextIconButton({
    super.key,
    this.onPressed,
    this.widget,
    required this.label,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(
        label,
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
          color: BohibaColors.white,
        ),
      ),
      icon: widget,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? ScreenUtils.width * 0.9, height ?? 47),
        backgroundColor: color ?? BohibaColors.primaryColor,
      ),
    );
  }
}
