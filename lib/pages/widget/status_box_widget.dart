import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusBoxWidget extends StatelessWidget {
  final VoidCallback? onClick;
  final String header;
  final String? title;
  final Color? titleColor;
  final bool showArrow;
  const StatusBoxWidget({
    super.key,
    this.onClick,
    this.header = 'NA',
    this.title,
    this.titleColor,
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
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color:
                    bohibaTheme.colorScheme.onSurface.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                title ?? '',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                  color: titleColor ?? bohibaTheme.textTheme.bodyLarge!.color,
                ),
              ),
            ),
            Visibility(
              visible: showArrow,
              child: Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: ScreenUtils.height20.h,
                  color: BohibaColors.tileColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
