import 'dart:math';
import 'package:flutter/material.dart';

class RandomColorPicker {
  /// ✅ Method 1: All colors
  static List<Color> getAllColors() {
    return [
      Color(0xff64b5f6),
      Color(0xff42a5f5),
      Color(0xff2196f3),
      Color(0xff1e88e5),
      Color(0xff1976d2),
      Color(0xff1565c0),
      Color(0xff0d47a1),
    ];
  }

  /// ✅ Method 2: Random color
  static Color getRandomColor() {
    final colors = getAllColors();
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }
}
