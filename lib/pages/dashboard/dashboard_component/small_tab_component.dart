import 'package:auto_size_text/auto_size_text.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class SmallTabComponent extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  // final bool alwaysScroll;
  const SmallTabComponent({
    super.key,
    required this.onTap,
    this.label = "Label",
    this.icon = Icons.add,
    // this.alwaysScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ScreenUtils.height47,
        width: ScreenUtils.width * 0.25,
        margin: EdgeInsets.only(right: ScreenUtils.height20),
        decoration: BoxDecoration(
          color: BohibaColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: ScreenUtils.width * 0.108,
              width: ScreenUtils.width * 0.108,
              decoration: BoxDecoration(
                color: bohibaTheme.primaryColor,
                border: Border.all(color: BohibaColors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: BohibaColors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.adaptSize),
                child: AutoSizeText(
                  label,
                  style: bohibaTheme.textTheme.labelMedium,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflowReplacement: MarqueeText(
                    speed: 5,
                    style: bohibaTheme.textTheme.labelMedium,
                    textAlign: TextAlign.center,
                    alwaysScroll: false,
                    text: TextSpan(text: label),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
