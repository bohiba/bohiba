import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class BohibaMarqueeText extends StatelessWidget {
  final double width;
  final String text;
  final String overflowText;
  final bool alwaysScroll;
  final TextStyle? style;
  final TextStyle? marqueeTextStyle;
  final AlignmentGeometry? alignment;

  const BohibaMarqueeText({
    super.key,
    required this.width,
    required this.text,
    required this.overflowText,
    this.alwaysScroll = false,
    this.style,
    this.marqueeTextStyle,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      width: width,
      child: AutoSizeText(
        text,
        maxLines: 1,
        style: style,
        overflowReplacement: MarqueeText(
          speed: 10,
          alwaysScroll: alwaysScroll,
          style: marqueeTextStyle,
          text: TextSpan(
            text: overflowText,
          ),
        ),
      ),
    );
  }
}
