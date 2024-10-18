import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_colors.dart';

class CompleteButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final String label;

  const CompleteButton({
    Key? key,
    required this.width,
    required this.height,
    this.onPressed,
    this.label = "Complete Button",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(width, height),
          backgroundColor: bohibaColors.primaryColor),
      child: Text(label),
    );
  }
}
