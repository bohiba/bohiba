import 'package:flutter/material.dart';

import '/dist/component_exports.dart';

class AppBarIconBox extends StatelessWidget {
  const AppBarIconBox({super.key, this.toolTipMessage, this.richMessage, this.onTap, this.onTapDown, this.icon});

  final String? toolTipMessage;
  final InlineSpan? richMessage;
  final VoidCallback? onTap;
  final Function(TapDownDetails)? onTapDown;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      child: Container(
        margin: EdgeInsets.only(right: ScreenUtils.width10),
        alignment: Alignment.center,
        width: ScreenUtils.width40,
        color: Colors.transparent,
        child: icon,
      ),
    );
  }
}
