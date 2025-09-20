import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

import '../../dist/component_exports.dart';

class UtilityActionButton extends StatelessWidget {
  final Function(DragDownDetails)? onPanDown;
  final IconData icon;
  final String buttonName;
  const UtilityActionButton(
      {super.key,
      required this.onPanDown,
      required this.icon,
      required this.buttonName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: onPanDown,
      child: Container(
        height: 30,
        width: ScreenUtils.width * 0.175,
        margin: EdgeInsets.only(
          left: ScreenUtils.width5,
          right: ScreenUtils.width5,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: BohibaColors.primaryColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 16,
              color: BohibaColors.white,
            ),
            Text(
              buttonName,
              style: TextStyle(
                  fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                  color: BohibaColors.white
                  // color: bohibaTheme.textTheme.bodySmall!.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
