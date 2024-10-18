import 'package:flutter/material.dart';

class SecoundaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  final Size fixedSize;
  final RoundedRectangleBorder shape;
  final Color backgroundColor;

  const SecoundaryButton({
    Key? key,
    this.onPressed,
    this.label = 'Submit',
    this.fixedSize = const Size(125, 40),
    this.shape = const RoundedRectangleBorder(),
    this.backgroundColor = const Color(0xFF047BFC),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: fixedSize,
        shape: shape,
        backgroundColor: backgroundColor,
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}