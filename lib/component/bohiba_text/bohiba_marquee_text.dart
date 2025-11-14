import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class BohibaMarqueeText extends StatelessWidget {
  final double width;
  final String? text;
  final String? overflowText;
  final bool alwaysScroll;
  final TextStyle? style;
  final TextAlign? alignText;
  final TextStyle? marqueeTextStyle;
  final AlignmentGeometry? alignment;
  final double? minFontSize;
  final List<double>? preserFontSize;

  const BohibaMarqueeText({
    super.key,
    required this.width,
    required this.text,
    required this.overflowText,
    this.alwaysScroll = false,
    this.style,
    this.marqueeTextStyle,
    this.alignment,
    this.alignText,
    this.minFontSize,
    this.preserFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      width: width,
      child: AutoSizeText(
        text ?? '',
        maxLines: 1,
        style: style,
        textAlign: alignText,
        wrapWords: false,
        presetFontSizes: preserFontSize ?? [12],
        minFontSize: minFontSize ?? 12,
        overflowReplacement: MarqueeText(
          speed: 10,
          alwaysScroll: alwaysScroll,
          style: marqueeTextStyle,
          text: TextSpan(
            text: overflowText ?? '',
          ),
        ),
      ),
    );
  }
}
