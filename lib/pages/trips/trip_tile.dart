import 'package:bohiba/component/ui/random_color_picker.dart';
import 'package:remixicon/remixicon.dart';

import '/dist/component_exports.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';
import '/extensions/bohiba_extension.dart';
import '/extensions/ext_trip_status.dart';
import '/controllers/trip_controller.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
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
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtils.height5),
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtils.width15),
        width: ScreenUtils.width,
        // height: ScreenUtils.height * 0.075,
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
                  color: RandomColorPicker.getRandomColor(),
                ),
                // child: Text(
                //   tripInfo.id.toString(),
                //   style: TextStyle(
                //     fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                //     fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                //     color: bohibaTheme.textTheme.bodySmall!.color,
                //   ),
                // ),
              ),
              Gap(ScreenUtils.height15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tripInfo.origin?.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: bohibaTheme.textTheme.bodyMedium,
                    ),
                    Text(
                      tripInfo.destination?.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: bohibaTheme.textTheme.bodyMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${tripInfo.startDate?.toDDMMYYYY()}',
                          style: TextStyle(
                            fontSize:
                                bohibaTheme.textTheme.labelSmall!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.labelMedium!.fontWeight,
                            color: bohibaTheme.textTheme.titleLarge!.color,
                          ),
                        ),
                        Text(
                          tripInfo.tripStatus?.tripStatusName ?? '',
                          style: TextStyle(
                            fontSize:
                                bohibaTheme.textTheme.labelSmall!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.labelMedium!.fontWeight,
                            color: bohibaTheme.textTheme.titleLarge!.color,
                          ),
                        ),
                        if (tripInfo.truck?.regdNumber?.isEmpty ?? true)
                          SizedBox.fromSize()
                        else
                          Text(
                            tripInfo.truck?.regdNumber ?? '',
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.labelSmall!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.labelMedium!.fontWeight,
                              color: bohibaTheme.textTheme.titleLarge!.color,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: ScreenUtils.height * 0.075,
                width: ScreenUtils.width50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Icon(Remix.arrow_right_s_line),
              )
            ],
          ),
        ),
      ),
    );
  }
}
