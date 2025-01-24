import '/theme/light_theme.dart';
import 'package:flutter/material.dart';

import '../bohiba_colors.dart';

class PrimaryIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Widget icon;
  final Size fixedSize;
  final RoundedRectangleBorder shape;
  final Color backgroundColor;

  const PrimaryIconButton({
    super.key,
    this.onPressed,
    this.label = 'Submit',
    this.icon = const Icon(Icons.add),
    this.fixedSize = const Size(125, 40),
    this.shape = const RoundedRectangleBorder(),
    this.backgroundColor = const Color(0xFF047BFC),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(label,
          style: TextStyle(
              fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
              color: bohibaColors.white)),
      icon: icon,
      style: ElevatedButton.styleFrom(
          fixedSize: fixedSize, shape: shape, backgroundColor: backgroundColor),
    );
  }
}
