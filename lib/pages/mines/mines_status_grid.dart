import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import '/pages/mines/mines_page.dart';
import '/component/bohiba_text/bohiba_marquee_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinesStatusGrid extends StatelessWidget {
  final List<StatusModel> mineOutsideInfo;
  const MinesStatusGrid({super.key, this.mineOutsideInfo = const []});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtils.height15),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.65,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: index == 0 ? Radius.circular(8.r) : Radius.zero,
                bottomLeft: index == 0 ? Radius.circular(8.r) : Radius.zero,
                topRight: index == 2 ? Radius.circular(8.r) : Radius.zero,
                bottomRight: index == 2 ? Radius.circular(8.r) : Radius.zero,
              ),
              border: Border(
                top: BorderSide(color: bohibaTheme.dividerColor),
                left: index == 0 ? BorderSide(color: bohibaTheme.dividerColor) : BorderSide.none,
                right: BorderSide(color: bohibaTheme.dividerColor),
                bottom: BorderSide(color: bohibaTheme.dividerColor),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mineOutsideInfo[index].name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.titleSmall!.fontSize,
                    fontWeight: bohibaTheme.textTheme.headlineLarge!.fontWeight,
                    color: bohibaTheme.textTheme.titleSmall!.color,
                  ),
                ),
                BohibaMarqueeText(
                  width: ScreenUtils.width,
                  text: mineOutsideInfo[index].value ?? '',
                  overflowText: mineOutsideInfo[index].value ?? '',
                  style: bohibaTheme.textTheme.headlineMedium,
                  preserFontSize: [bohibaTheme.textTheme.headlineMedium!.fontSize!],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
