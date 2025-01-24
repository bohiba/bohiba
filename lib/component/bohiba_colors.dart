import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';

// Colors
class ColorSchemes {
  static const bohibaColorsScheme = ColorScheme.light();
}

class BohibaColors {
  Color get primaryColor => const Color.fromRGBO(4, 123, 252, 1);
  Color get primaryVariantColor => const Color.fromARGB(255, 183, 217, 254);

  Color get greyColor => const Color.fromRGBO(158, 158, 158, 1);
  Color get lightGreyColor => const Color.fromARGB(255, 245, 245, 245);
  Color get tileColor => const Color.fromRGBO(245, 245, 245, 1);
  Color get borderColor => const Color.fromRGBO(224, 224, 224, 1);
  Color get secoundaryColor => const Color.fromRGBO(158, 158, 158, 1);
  Color get bgColor => const Color.fromRGBO(255, 255, 255, 1);

  Color get white => const Color.fromRGBO(255, 255, 255, 1);
  Color get black => const Color.fromRGBO(29, 29, 29, 1);

  Color get successColor => const Color.fromRGBO(76, 175, 80, 1);
  Color get warningColor => const Color.fromRGBO(255, 82, 82, 1);
  Color get transparent => const Color.fromRGBO(0, 0, 0, 0);
}

BohibaColors get bohibaColors => ThemeHelper().themeColor();
