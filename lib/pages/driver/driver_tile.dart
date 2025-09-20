import 'dart:async';

import '/dist/app_enums.dart';
import '/pages/driver/driver_modals/driver_menu.dart';
import '/routes/app_route.dart';
import '/controllers/driver_controller.dart';
import '/model/driver_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:get/get.dart';

class DriverTile extends GetView<DriverController> {
  final DriverModel driver;
  final List<ActionType> allowedActions;
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>?
      onActionComplete;
  const DriverTile({
    super.key,
    required this.driver,
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
              onTap: () {
                Get.toNamed(AppRoute.driver, arguments: driver);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: BohibaColors.white,
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
                        driver.licenseDetail?.licenseNumber ?? 'NA',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                          color: bohibaTheme.textTheme.titleLarge!.color,
                        ),
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
