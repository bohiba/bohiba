import '/theme/bohiba_theme.dart';
import '/dist/component_exports.dart';
import 'package:flutter/material.dart';

class SubInfoTile extends StatelessWidget {
  final EdgeInsets? padding;
  final String? title;
  final String? data;
  final Widget? widget;
  final bool enableBorder;
  final VoidCallback? onClick;
  const SubInfoTile({
    super.key,
    this.padding,
    this.title,
    this.data,
    this.enableBorder = true,
    this.widget,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: ScreenUtils.height15,
              vertical: ScreenUtils.width10,
            ),
        decoration: enableBorder
            ? BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(width: 1.0, color: BohibaColors.borderColor),
                ),
              )
            : BoxDecoration(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? "",
                  style: bohibaTheme.textTheme.titleLarge,
                ),
                widget ??
                    Text(
                      data ?? "",
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        color: bohibaTheme.textTheme.bodySmall!.color,
                      ),
                    )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
