import 'package:flutter/material.dart';
import '/component/bohiba_colors.dart';

class CompleteButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final String label;

  const CompleteButton({
    super.key,
    required this.width,
    required this.height,
    this.onPressed,
    this.label = "Complete Button",
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(width, height),
          backgroundColor: BohibaColors.primaryColor),
      child: Text(label),
    );
  }
}
