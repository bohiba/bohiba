import '/model/driver_model.dart';
import '/component/bohiba_text/bohiba_marquee_text.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class OpenDriverTile extends StatelessWidget {
  final DriverModel openDriver;
  final Function()? onTap;
  final bool? showStatus;

  const OpenDriverTile({
    super.key,
    required this.openDriver,
    this.onTap,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  text: openDriver.profile?.name ?? '',
                  overflowText: openDriver.profile?.name ?? '',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                  marqueeTextStyle: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${openDriver.address?.district ?? ''} ",
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.labelMedium!.fontWeight,
                        color: bohibaTheme.textTheme.bodyLarge!.color,
                      ),
                    ),
                    Gap(5.w),
                    Text(
                      openDriver.address?.state ?? '',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.labelMedium!.fontWeight,
                        color: bohibaTheme.textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            if (showStatus == true)
              Text(openDriver.profile?.connect?.capitalizeFirst ?? '')
            else
              SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
