import 'package:flutter/material.dart';

class TrailingButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color iconColor;
  const TrailingButton(
      {super.key,
      this.onTap,
      required this.icon,
      this.iconColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
          )),
    );
  }
}
