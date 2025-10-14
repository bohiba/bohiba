import 'package:auto_size_text/auto_size_text.dart';
import '/component/screen_utils.dart';
import '/pages/driver/driver_modals/driver_menu.dart';
import '/theme/bohiba_theme.dart';
import 'package:marquee_text/marquee_text.dart';
import '/controllers/driver_controller.dart';
import '/dist/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          DriverMenu(
            driver: controller.driverModel.value,
            allowedActions: [
              ActionType.share,
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
