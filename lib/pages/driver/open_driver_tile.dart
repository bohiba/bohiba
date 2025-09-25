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
  const OpenDriverTile({super.key, required this.openDriver});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtils.height * 0.075,
        width: ScreenUtils.width,
        margin: EdgeInsets.only(bottom: 5.h),
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtils.height5,
          horizontal: ScreenUtils.width15,
        ),
        decoration: TileDecorative(),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: bohibaTheme.dividerColor,
            ),
            Gap(10.w),
            // Text(openDriver.name ?? ''),
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
            TextButton(
              onPressed: () {},
              child: Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
