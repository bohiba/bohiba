import 'package:flutter/material.dart';

import '../bohiba_colors.dart';

class PrimaryFloatingButton extends StatelessWidget {
  final String label;
  final Object? heroTag;
  final VoidCallback onPressed;

  const PrimaryFloatingButton(
      {super.key, this.heroTag, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width * 0.5,
      height: height * 0.070,
      child: FloatingActionButton(
        heroTag: heroTag,
        elevation: 0,
        onPressed: onPressed,
        backgroundColor: BohibaColors.primaryColor,
        child: Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}
