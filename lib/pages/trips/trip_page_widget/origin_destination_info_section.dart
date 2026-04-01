import '/component/bohiba_text/bohiba_marquee_text.dart';
import '/component/screen_utils.dart';
import '/extensions/bohiba_extension.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

class OriginDestinationInfoSection extends StatelessWidget {
  final TripModel? tripInfo;
  const OriginDestinationInfoSection({super.key, this.tripInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.height15,
        bottom: ScreenUtils.height10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                BohibaMarqueeText(
                  width: ScreenUtils.width * 0.32,
                  text: tripInfo?.origin?.name ?? '',
                  style: bohibaTheme.textTheme.headlineMedium,
                  alignment: Alignment.center,
                  alignText: TextAlign.center,
                  overflowText: tripInfo?.origin?.nameCode ?? '',
                  marqueeTextStyle: bohibaTheme.textTheme.headlineMedium,
                  preserFontSize: [
                    bohibaTheme.textTheme.headlineMedium!.fontSize!,
                  ],
                  minFontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                ),
                Text(
                  tripInfo?.startDate?.toDDMMYYYY() ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleMedium!.color,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            RemixIcons.arrow_right_double_line,
            color: bohibaTheme.primaryColor,
            size: 32.w,
          ),
          Expanded(
            child: Column(
              children: [
                BohibaMarqueeText(
                  width: ScreenUtils.width * 0.32,
                  text: tripInfo?.destination?.name ?? '',
                  alignment: Alignment.center,
                  alignText: TextAlign.center,
                  style: bohibaTheme.textTheme.headlineMedium,
                  overflowText: tripInfo?.destination?.nameCode ?? '',
                  marqueeTextStyle: bohibaTheme.textTheme.headlineMedium,
                  preserFontSize: [
                    bohibaTheme.textTheme.headlineMedium!.fontSize!,
                  ],
                  minFontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                ),
                Text(
                  tripInfo?.endedDate?.toDDMMYYYY() ?? '',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleMedium!.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
