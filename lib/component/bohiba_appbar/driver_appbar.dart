import 'package:auto_size_text/auto_size_text.dart';
import '/component/screen_utils.dart';
import '/pages/driver/driver_modals/driver_menu.dart';
import '/theme/bohiba_theme.dart';
import 'package:marquee_text/marquee_text.dart';

import '/component/bohiba_appbar/appbar_icon.dart';
import '/component/bohiba_colors.dart';
import '/controllers/driver_controller.dart';
import '/dist/app_enums.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class DriverAppbar extends GetView<DriverController>
    implements PreferredSizeWidget {
  const DriverAppbar({super.key});
  @override
  Widget build(BuildContext context) {
    final NavigatorState navState = Navigator.of(context);
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: SizedBox(
          width: ScreenUtils.width * 0.45,
          child: AutoSizeText(
            controller.driverModel.value.profile?.name ?? 'NA',
            maxLines: 1,
            style: bohibaTheme.appBarTheme.titleTextStyle,
            overflowReplacement: MarqueeText(
              speed: 10,
              alwaysScroll: true,
              style: bohibaTheme.appBarTheme.titleTextStyle,
              text: TextSpan(
                text: controller.driverModel.value.profile?.name ?? 'NA',
              ),
            ),
          ),
        ),
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios_new_rounded),
          onTap: () {
            navState.pop(true);
          },
        ),
        actions: [
          Obx(
            () {
              return AppBarIconBox(
                onTap: () async => await controller
                    .toggleFav(
                  assetId: controller.driverModel.value.id!.toString(),
                  driver: controller.driverModel.value,
                )
                    .then(
                  (onValue) async {
                    await controller.getDriverInfo(
                      id: controller.driverModel.value.id!.toString(),
                    );
                    controller.driverModel.refresh();
                    GlobalService.printHandler(
                        'Is marked fav: ${controller.driverModel.value.isFav}');
                  },
                ),
                icon: controller.driverModel.value.isFav == true
                    ? Icon(
                        Icons.favorite_rounded,
                        color: BohibaColors.warningColor,
                      )
                    : Icon(Remix.heart_3_line),
              );
            },
          ),
          DriverMenu(
            driver: controller.driverModel.value,
            allowedActions: [
              // ActionType.route,
              ActionType.other,
              ActionType.delete,
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55);
}
