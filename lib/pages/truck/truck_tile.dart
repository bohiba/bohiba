import 'dart:async';

import '/pages/truck/add_truck_component/truck_menu.dart';
import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/truck_all_controller.dart';
import '/model/truck_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class TruckTile extends GetView<TruckAllController> {
  final VoidCallback? onClick;
  final TruckModel truckInfo;
  final List<ActionType> allowedActions;
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>?
      onActionComplete;
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
      margin: EdgeInsets.only(bottom: ScreenUtils.width5),
      width: ScreenUtils.width,
      height: ScreenUtils.height * 0.075,
      decoration: TileDecorative(),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onClick,
              child: Row(
                children: [
                  Container(
                    width: ScreenUtils.width * 0.095,
                    height: ScreenUtils.width * 0.095,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: BohibaColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Remix.truck_line,
                      color: BohibaColors.white,
                    ),
                  ),
                  Gap(ScreenUtils.height15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truckInfo.regdNumber ?? 'NA',
                        maxLines: 1,
                        style: bohibaTheme.textTheme.bodyMedium,
                      ),
                      Text(
                        truckInfo.driver?.name ?? 'Not Assigned',
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
