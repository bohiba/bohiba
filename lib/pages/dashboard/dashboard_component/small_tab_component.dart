import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        margin: EdgeInsets.only(right: ScreenUtils.height10),
        decoration: TileDecorative(color: bohibaTheme.colorScheme.surface),
        child: Row(
          children: [
            Container(
              height: ScreenUtils.width * 0.108,
              width: ScreenUtils.width * 0.108,
              margin: EdgeInsets.all(1.0),
              decoration: TileDecorative(color: bohibaTheme.primaryColor),
              child: Icon(
                icon,
                color: bohibaTheme.colorScheme.surface,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: AutoSizeText(
                  label,
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                    fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                    fontFamily: bohibaTheme.textTheme.labelMedium!.fontFamily,
                    color: bohibaTheme.textTheme.labelMedium!.color,
                  ),
                  presetFontSizes: [
                    bohibaTheme.textTheme.labelMedium!.fontSize!,
                  ],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflowReplacement: MarqueeText(
                    speed: 5,
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                      fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                      fontFamily: bohibaTheme.textTheme.labelMedium!.fontFamily,
                      color: bohibaTheme.textTheme.labelMedium!.color,
                    ),
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
