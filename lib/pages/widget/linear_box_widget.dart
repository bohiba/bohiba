import '/dist/component_exports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class LinearBoxWidget extends StatelessWidget {
  final VoidCallback? onClick;
  final String header;
  final String? title;
  final Color? titleColor;
  final bool showArrow;
  final Widget? widget;
  const LinearBoxWidget({
    super.key,
    this.onClick,
    this.header = 'NA',
    this.title,
    this.titleColor,
    this.showArrow = false,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtils.height15),
        decoration: BoxDecoration(
          color: titleColor,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: bohibaTheme.dividerColor,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              header,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                color: bohibaTheme.textTheme.titleMedium!.color,
              ),
            ),
            Spacer(),
            if (title != null)
              BohibaMarqueeText(
                width: 160.w,
                text: title ?? '',
                overflowText: title ?? '',
                alignment: Alignment.centerRight,
                marqueeTextStyle: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                  color: titleColor ?? bohibaTheme.textTheme.bodyLarge!.color,
                ),
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                  color: titleColor ?? bohibaTheme.textTheme.bodyLarge!.color,
                ),
              ),
            if (showArrow == true)
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: ScreenUtils.height15.h,
                  color: bohibaTheme.primaryColor,
                ),
              ),
            widget ?? Container(),
          ],
        ),
      ),
    );
  }
}
