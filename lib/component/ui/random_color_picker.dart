import 'dart:math';
import 'package:flutter/material.dart';

class RandomColorPicker {
  /// ✅ Method 1: All colors
  static List<Color> getAllColors() {
    return [
      Color(0xFF264653),
      Color(0xFF2A9D8F),
      Color(0xFF8AB17D),
      Color(0xFFE9C46A),
      Color(0xFFF4A261),
      Color(0xFFE76F51),
      Color(0xFFB56576),
    ];
  }

  /// ✅ Method 2: Random color
  static Color getRandomColor() {
    final colors = getAllColors();
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }
}
