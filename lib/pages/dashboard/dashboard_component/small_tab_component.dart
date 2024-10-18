import 'package:auto_size_text/auto_size_text.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class SmallTabComponent extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  // final bool alwaysScroll;
  const SmallTabComponent({
    Key? key,
    required this.onTap,
    this.label = "Label",
    this.icon = Icons.add,
    // this.alwaysScroll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 110,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF047BFC),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
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
