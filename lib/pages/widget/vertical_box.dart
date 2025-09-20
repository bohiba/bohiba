


import '/component/bohiba_text/bohiba_marquee_text.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class TripInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const TripInfoItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = bohibaTheme.textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtils.height10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: theme.bodyMedium!.fontSize,
              fontWeight: theme.bodySmall!.fontWeight,
              color: theme.titleMedium!.color,
            ),
          ),
          BohibaMarqueeText(
            width: ScreenUtils.width,
            text: value,
            overflowText: value,
            alignment: Alignment.centerLeft,
            marqueeTextStyle: TextStyle(
              fontSize: theme.bodyMedium!.fontSize,
              fontWeight: theme.bodyLarge!.fontWeight,
              color: theme.bodyLarge!.color,
            ),
            style: TextStyle(
              fontSize: theme.bodyMedium!.fontSize,
              fontWeight: theme.bodyLarge!.fontWeight,
              color: theme.bodyLarge!.color,
            ),
          ),
        ],
      ),
    );
  }
}
