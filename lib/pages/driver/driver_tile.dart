import 'dart:async';

import '/component/bohiba_network_image.dart';
import '/component/image_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/dist/enums/app_enums.dart';
import '/pages/driver/driver_modals/driver_menu.dart';
import '/controllers/driver_controller.dart';
import '/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:get/get.dart';

class DriverTile extends GetView<DriverController> {
  final UserModel driver;
  final Function()? onPressed;
  final List<ActionType> allowedActions;
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>?
      onActionComplete;
  const DriverTile({
    super.key,
    required this.driver,
    required this.onPressed,
    required this.allowedActions,
    this.onActionComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: ScreenUtils.width15),
      width: ScreenUtils.width,
      height: ScreenUtils.height * 0.075,
      margin: EdgeInsets.only(bottom: ScreenUtils.width5),
      decoration: TileDecorative(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: onPressed,
              child: Row(
                children: [
                  BohibaNetworkImage.circle(
                    imageUrl: '${ImagePath.profileImage}/${driver.profile?.image}',
                    size: 32.h,
                    fallbackText: driver.profile?.name,
                  ),
                  Gap(ScreenUtils.height15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.profile?.name ?? '',
                        maxLines: 1,
                        style: bohibaTheme.textTheme.bodyMedium,
                      ),
                      Text(
                        driver.profile?.driverUuid ?? '',
                        maxLines: 1,
                        style: bohibaTheme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          DriverMenu(
            allowedActions: allowedActions,
            driver: driver,
            onActionComplete: onActionComplete,
          )
        ],
      ),
    );
  }
}
