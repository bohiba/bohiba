import 'package:bohiba/dist/component_exports.dart';
import 'package:remixicon/remixicon.dart';

import '/model/truck_model.dart';
import '/pages/truck/add_truck_component/truck_menu.dart';
import '/dist/enums/app_enums.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/truck_controller.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TruckAppbar extends GetView<TruckController>
    implements PreferredSizeWidget {
  final TruckModel? truck;
  final bool popResult;
  const TruckAppbar({super.key, required this.truck, this.popResult = false});

  @override
  Widget build(BuildContext context) {
    final navigate = Navigator.of(context);
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: SizedBox(
          width: ScreenUtils.width * 0.45,
          child: AutoSizeText(
            controller.truckModel.value?.regdNumber ?? '',
            maxLines: 1,
            style: bohibaTheme.appBarTheme.titleTextStyle,
            overflowReplacement: MarqueeText(
              speed: 10,
              alwaysScroll: true,
              style: bohibaTheme.appBarTheme.titleTextStyle,
              text: TextSpan(
                text: controller.truckModel.value?.regdNumber ?? '',
              ),
            ),
          ),
        ),
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios_new_rounded),
          onTap: () {
            navigate.pop(popResult);
          },
        ),
        actions: [
          Obx(
            () {
              return AppBarIconBox(
                onTap: () async => controller.syncFavourite(),
                icon: (controller.truckModel.value?.isFav ?? false)
                    ? Icon(
                        Icons.favorite_rounded,
                        color: BohibaColors.warningColor,
                      )
                    : Icon(Remix.heart_3_line),
              );
            },
          ),
          Visibility(
            visible: controller.truckModel.value != null,
            child: TruckMenu(
              truck: truck,
              allowedActions: [
                ActionType.edit,
                // ActionType.add,
                // ActionType.sync,
                // ActionType.other,
                ActionType.delete,
              ],
              onActionComplete: {
                ActionType.edit: (value) async {
                  await controller.getTruckInfo(
                    truckFetchValue: controller.truckId.value,
                  );
                },
                ActionType.delete: (delete) async {
                  if (delete > 0) {
                    navigate.pop(true);
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
