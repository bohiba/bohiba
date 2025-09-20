import 'package:flutter/material.dart';

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';

class FilterHeaderWidget extends StatelessWidget {
  final VoidCallback onPressTrailing;
  final String title;
  const FilterHeaderWidget({
    super.key,
    required this.onPressTrailing,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtils.height15, bottom: ScreenUtils.height10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                color: bohibaTheme.textTheme.bodySmall!.color),
          ),
          GestureDetector(
            onTap: onPressTrailing,
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
