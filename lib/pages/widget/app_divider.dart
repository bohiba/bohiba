import 'package:flutter/material.dart';

import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';

class AppDivider extends StatelessWidget {
  final double? width;
  final double? thickness;
  final double? radius;
  final Color? color;
  const AppDivider({
    super.key,
    this.width,
    this.thickness,
    this.radius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: thickness ?? 1.5,
      width: width ?? ScreenUtils.width50,
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtils.width10,
      ),
      decoration: BoxDecoration(
        color: color ?? BohibaColors.borderColor,
        borderRadius: BorderRadius.circular(radius ?? 10.0),
      ),
    );
  }
}
