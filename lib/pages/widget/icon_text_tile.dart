import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class IconTextTile extends StatelessWidget {
  final IconData? icon;
  final String text;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? widget;
  const IconTextTile({
    super.key,
    this.icon,
    required this.text,
    this.subtitle,
    this.widget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ScreenUtils.width,
        padding: EdgeInsets.symmetric(vertical: ScreenUtils.height10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: bohibaTheme.dividerColor,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: ScreenUtils.height47,
              width: ScreenUtils.height47,
              decoration: BoxDecoration(
                color: bohibaTheme.listTileTheme.tileColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(icon),
            ),
            Gap(ScreenUtils.width25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: bohibaTheme.textTheme.titleLarge,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle ?? '',
                      style: bohibaTheme.textTheme.titleSmall,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                ],
              ),
            ),
            widget ?? Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
