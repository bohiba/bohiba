import 'package:flutter/material.dart';

import '../bohiba_colors.dart';

class BottomNavButton extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final VoidCallback? onPressed;

  const BottomNavButton(
      {Key? key,
      this.onPressed,
      this.height = 47,
      this.width = 210,
      this.label = "Label"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: bohibaColors.primaryColor,
          fixedSize: Size(width, height)),
      child: Text(
        label,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
            color: bohibaColors.white),
      ),
    );
  }
}
