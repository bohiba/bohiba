import '/dist/component_exports.dart';

import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';
import '/extensions/bohiba_extension.dart';
import '/controllers/trip_controller.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class TripTile extends GetView<TripController> {
  final TripModel tripInfo;
  final VoidCallback? onClick;
  const TripTile({
    super.key,
    required this.tripInfo,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    Color? colors = bohibaTheme.textTheme.titleLarge!.color;
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtils.height5),
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtils.width15),
        width: ScreenUtils.width,
        height: ScreenUtils.height * 0.075,
        decoration: TileDecorative(),
        child: InkWell(
          onTap: onClick,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 32.h,
                width: 32.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bohibaTheme.colorScheme.tertiary,
                ),
                child: Text(
                  tripInfo.tripStatus?.shortCode ?? '',
                  // tripInfo.id.toString(),
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                    color: bohibaTheme.textTheme.bodySmall!.color,
                  ),
                ),
              ),
              Gap(ScreenUtils.height15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tripInfo.truck?.regdNumber ?? '',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                      color: bohibaTheme.textTheme.labelLarge!.color,
                    ),
                  ),
                  BohibaMarqueeText(
                    width: ScreenUtils.width * 0.45,
                    text: tripInfo.origin?.toUpperCase(),
                    overflowText: tripInfo.origin?.toUpperCase(),
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                      letterSpacing: bohibaTheme.textTheme.labelMedium!.letterSpacing,
                      fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                      color: colors,
                    ),
                    marqueeTextStyle: TextStyle(
                      fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                      letterSpacing: bohibaTheme.textTheme.labelMedium!.letterSpacing,
                      fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                      color: colors,
                    ),
                    preserFontSize: [
                      bohibaTheme.textTheme.labelMedium!.fontSize!,
                    ],
                  ),
                  Text(
                    tripInfo.startDate ?? '',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.labelSmall!.fontSize,
                      fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                      color: colors,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                child: Container(
                  height: ScreenUtils.height * 0.075,
                  width: ScreenUtils.width50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Icon(EvaIcons.arrowIosForwardOutline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
