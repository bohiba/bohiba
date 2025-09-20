import '/controllers/trip_controller.dart';
import 'package:get/get.dart';

import '/component/bohiba_colors.dart';
import '/model/trip_model.dart';

import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
              CircleAvatar(
                radius: 20,
                backgroundColor: BohibaColors.greyColor,
                // backgroundImage: NetworkImage(GlobalService.getAvatarUrl('')),
              ),
              Gap(ScreenUtils.height15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tripInfo.tripCode ?? 'NA',
                    maxLines: 1,
                    style: bohibaTheme.textTheme.bodyMedium,
                  ),
                  Text(
                    tripInfo.truck?.regdNumber ?? '',
                    // '${tripInfo.origin} - ${tripInfo.destination}',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
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
