import 'package:auto_size_text/auto_size_text.dart';
import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/theme/light_theme.dart';
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
        height: BohibaResponsiveScreen.height47,
        width: BohibaResponsiveScreen.width * 0.25,
        margin: EdgeInsets.only(right: BohibaResponsiveScreen.height20),
        decoration: BoxDecoration(
          color: bohibaColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: BohibaResponsiveScreen.width * 0.108,
              width: BohibaResponsiveScreen.width * 0.108,
              decoration: BoxDecoration(
                color: const Color(0xFF047BFC),
                border: Border.all(color: bohibaColors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: bohibaColors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
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
