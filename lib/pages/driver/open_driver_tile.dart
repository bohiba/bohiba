import '/extensions/bohiba_extension.dart';
import '/model/open_driver_model.dart';

import '/component/bohiba_text/bohiba_marquee_text.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OpenDriverTile extends StatelessWidget {
  final OpenDriverModel openDriver;
  final Function()? onPressConnect;
  const OpenDriverTile(
      {super.key, required this.openDriver, this.onPressConnect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
        margin: EdgeInsets.only(bottom: ScreenUtils.width5),
        width: ScreenUtils.width,
        height: ScreenUtils.height * 0.075,
        decoration: TileDecorative(),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: bohibaTheme.dividerColor,
            ),
            Gap(10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BohibaMarqueeText(
                  width: ScreenUtils.width * 0.5,
                  text: openDriver.name ?? '',
                  overflowText: openDriver.name ?? '',
                  style: bohibaTheme.textTheme.bodyMedium,
                  marqueeTextStyle: bohibaTheme.textTheme.bodyMedium,
                ),
                BohibaMarqueeText(
                  width: ScreenUtils.width * 0.3,
                  text: openDriver.jobStatus!.toCapitalizedLabel(),
                  overflowText: openDriver.jobStatus!.toCapitalizedLabel(),
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                  marqueeTextStyle: TextStyle(
                    fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: onPressConnect,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtils.height10),
                child: Text(
                  'Connect',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                    color: bohibaTheme.textTheme.bodySmall!.color,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
