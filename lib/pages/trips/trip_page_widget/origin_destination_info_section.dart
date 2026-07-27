import 'package:gap/gap.dart';

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
        left: ScreenUtils.width8,
        right: ScreenUtils.width8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tripInfo?.origin?.name ?? '',
                  textAlign: TextAlign.center,
                  style: bohibaTheme.textTheme.labelLarge,
                ),
              ),
              SizedBox(
                width: 32.w,
                height: 32.w,
                child: Icon(
                  RemixIcons.arrow_right_double_line,
                  color: bohibaTheme.primaryColor,
                  size: 32.w,
                ),
              ),
              Expanded(
                child: Text(
                  tripInfo?.destination?.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: bohibaTheme.textTheme.labelLarge,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  tripInfo?.startDate?.toDDMMYYYY() ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleMedium!.color,
                  ),
                ),
              ),
              Gap(32.w),
              Expanded(
                child: Text(
                  tripInfo?.endedDate?.toDDMMYYYY() ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleMedium!.color,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
