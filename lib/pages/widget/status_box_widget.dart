import '/extensions/bohiba_extension.dart';

import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusBoxWidget extends StatelessWidget {
  final VoidCallback? onClick;
  final String header;
  final String? title;
  final Widget? widget;
  final Color? statusColor;
  final bool showArrow;
  const StatusBoxWidget({
    super.key,
    this.onClick,
    this.header = 'NA',
    this.title,
    this.widget,
    this.statusColor,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtils.height10),
        decoration: BoxDecoration(
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
            if (widget == null)
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: statusColor ??
                      bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  title?.toCapitalizedLabel() ?? '',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                    color: bohibaTheme.textTheme.displayLarge!.color,
                  ),
                ),
              ),
            widget ?? SizedBox.shrink(),
            Visibility(
              visible: showArrow,
              child: Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.sp,
                  color: bohibaTheme.cardColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
