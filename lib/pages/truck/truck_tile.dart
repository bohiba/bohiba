import 'dart:async';
import '/component/image_path.dart';
import '/extensions/bohiba_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/pages/widget/role_widget.dart';

import '/pages/truck/add_truck_component/truck_menu.dart';
import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/truck_all_controller.dart';
import '/model/truck_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TruckTile extends GetView<TruckAllController> {
  final VoidCallback? onClick;
  final TruckModel truckInfo;
  final List<ActionType> allowedActions;
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>? onActionComplete;
  const TruckTile({
    super.key,
    this.onClick,
    required this.truckInfo,
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
        children: [
          Expanded(
            child: InkWell(
              onTap: onClick,
              child: Row(
                children: [
                  truckInfo.truckImage == null
                      ? Container(
                          height: 32.h,
                          width: 32.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bohibaTheme.colorScheme.tertiary,
                          ),
                          child: Text(
                            truckInfo.regdNumber?.shortCode ?? '',
                            style: TextStyle(
                              fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                              fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                              color: bohibaTheme.textTheme.bodySmall!.color,
                            ),
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
                              imageUrl: '${ImagePath.truckImage}/${truckInfo.truckImage}',
                              fit: BoxFit.cover,
                              height: 32.h,
                              width: 32.h,
                              placeholder: (context, url) => Container(
                                color: bohibaTheme.cardColor,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.broken_image,
                                size: 20,
                                color: bohibaTheme.cardColor,
                              ),
                            ),
                          ),
                        ),
                  Gap(ScreenUtils.height15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truckInfo.regdNumber ?? '',
                        maxLines: 1,
                        style: bohibaTheme.textTheme.bodyMedium,
                      ),
                      RoleWidget(
                        truckOwnerWidget: Text(
                          truckInfo.driverName ?? 'Not Assigned',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                            color: bohibaTheme.textTheme.titleMedium!.color,
                          ),
                        ),
                        driverWidget: truckInfo.ownerName != null
                            ? Text(
                                truckInfo.ownerName ?? '',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                                  fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                  color: bohibaTheme.textTheme.titleMedium!.color,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          TruckMenu(
            truck: truckInfo,
            allowedActions: allowedActions,
            onActionComplete: onActionComplete,
            icon: Icon(Icons.more_vert_rounded),
          )
        ],
      ),
    );
  }
}
