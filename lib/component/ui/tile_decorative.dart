import 'package:flutter/material.dart';
import '../bohiba_colors.dart';

class TileDecoration extends BoxDecoration {
  TileDecoration()
      : super(
          gradient: RadialGradient(
            colors: [
              bohibaColors.tileColor,
              bohibaColors.white,
            ],
            radius: 10,
            center: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
        );
}
