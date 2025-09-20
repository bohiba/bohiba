import 'package:flutter/material.dart';

import '/dist/component_exports.dart';

class AppBarIconBox extends StatelessWidget {
  const AppBarIconBox({super.key, this.onTap, this.onTapDown, this.icon});

  final VoidCallback? onTap;
  final Function(TapDownDetails)? onTapDown;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          right: ScreenUtils.width10,
        ),
        width: ScreenUtils.width40,
        child: icon,
      ),
    );
  }
}
