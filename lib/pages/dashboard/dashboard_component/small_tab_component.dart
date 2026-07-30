import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class SmallTabComponent extends StatelessWidget {
  final VoidCallback onTap;
  final void Function(TapDownDetails tapDetails)? onTapDown;
  final String label;
  final IconData icon;

  const SmallTabComponent({
    super.key,
    required this.onTap,
    this.onTapDown,
    this.label = "Label",
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelMedium;

    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      child: Container(
        height: ScreenUtils.height47,
        width: ScreenUtils.width * 0.25,
        margin: EdgeInsets.only(right: ScreenUtils.height10),
        decoration: TileDecorative(color: theme.colorScheme.surface),
        child: Row(
          children: [
            Container(
              height: ScreenUtils.width * 0.108,
              width: ScreenUtils.width * 0.108,
              margin: const EdgeInsets.all(1.0),
              decoration: TileDecorative(color: theme.primaryColor),
              child: Icon(
                icon,
                color: theme.colorScheme.surface,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: AutoSizeText(
                  label,
                  style: labelStyle,
                  presetFontSizes: [labelStyle?.fontSize ?? 12.sp],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflowReplacement: MarqueeText(
                    speed: 5,
                    style: labelStyle,
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
