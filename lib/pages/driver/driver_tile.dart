import 'dart:async';

import '/dist/app_enums.dart';
import '/pages/driver/driver_modals/driver_menu.dart';
import '/controllers/driver_controller.dart';
import '/model/driver_model.dart';
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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtils.width15),
        width: ScreenUtils.width,
        height: ScreenUtils.height * 0.075,
        margin: EdgeInsets.only(bottom: ScreenUtils.width5),
        decoration: TileDecorative(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: bohibaTheme.dividerColor,
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
                        driver.licenseDetail?.licenseNumber ?? '',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleMedium!.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DriverMenu(
              allowedActions: allowedActions,
              driver: driver,
              onActionComplete: onActionComplete,
            )
          ],
        ),
      ),
    );
  }
}
