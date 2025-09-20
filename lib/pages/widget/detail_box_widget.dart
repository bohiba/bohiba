import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class DetailsBox extends StatelessWidget {
  final String headline;
  final String title;
  final Color? titleColor;
  final VoidCallback? onClick;
  const DetailsBox({
    super.key,
    this.headline = '',
    this.title = '',
    this.titleColor,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: ScreenUtils.width10),
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: ScreenUtils.height47,
          constraints: BoxConstraints(
            minWidth: ScreenUtils.width * 0.3,
          ),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width10),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: bohibaTheme.dividerColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                headline,
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                  color: bohibaTheme.textTheme.bodyLarge!.color,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                  color: titleColor ?? bohibaTheme.textTheme.titleMedium!.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
