import 'dart:async';

import '/component/image_path.dart';
import '/extensions/bohiba_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>? onActionComplete;
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
                  Container(
                    height: 32.h,
                    width: 32.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bohibaTheme.colorScheme.surface,
                    ),
                    child: driver.profile?.image == null || (driver.profile?.image?.isEmpty ?? true)
                        ? Text(
                            driver.profile?.name?.shortCode ?? '',
                            style: TextStyle(
                              fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                              fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                              color: bohibaTheme.textTheme.bodySmall!.color,
                            ),
                          )
                        : Container(
                            height: 32.h,
                            width: 32.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: bohibaTheme.dividerColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(35.r),
                              child: CachedNetworkImage(
                                  imageUrl: '${ImagePath.profileImage}/${driver.profile?.image}',
                                  fit: BoxFit.cover,
                                  height: 32.h,
                                  width: 32.h,
                                  placeholder: (context, url) => Container(
                                        color: bohibaTheme.cardColor,
                                      ),
                                  errorWidget: (context, url, error) => Container(
                                        height: 32.h,
                                        width: 32.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: bohibaTheme.colorScheme.surface,
                                        ),
                                        child: Text(
                                          driver.profile?.name?.shortCode ?? '',
                                          style: TextStyle(
                                            fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                                            fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                                            color: bohibaTheme.textTheme.bodySmall!.color,
                                          ),
                                        ),
                                      )),
                            ),
                          ),
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
                      driver.licenseDetail?.licenseNumber == null || (driver.licenseDetail?.licenseNumber?.isEmpty ?? true)
                          ? SizedBox.shrink()
                          : Text(
                              driver.licenseDetail?.licenseNumber ?? '',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                                fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.titleMedium!.color,
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
