import '/component/bohiba_text/bohiba_marquee_text.dart';
import '/component/screen_utils.dart';
import '/pages/driver/driver_modals/driver_menu.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/driver_controller.dart';
import '../../dist/enums/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverAppbar extends GetView<DriverController> implements PreferredSizeWidget {
  const DriverAppbar({super.key});
  @override
  Widget build(BuildContext context) {
    final NavigatorState navState = Navigator.of(context);
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: BohibaMarqueeText(
          width: ScreenUtils.width * 0.5,
          text: controller.driverModel.value?.profile?.name,
          style: bohibaTheme.appBarTheme.titleTextStyle,
          overflowText: controller.driverModel.value?.profile?.name,
          marqueeTextStyle: bohibaTheme.appBarTheme.titleTextStyle,
          preserFontSize: [bohibaTheme.appBarTheme.titleTextStyle!.fontSize!],
          alwaysScroll: true,
        ),
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios_new_rounded),
          onTap: () {
            navState.pop(true);
          },
        ),
        actions: [
          controller.driverModel.value == null
              ? SizedBox.shrink()
              : DriverMenu(
                  driver: controller.driverModel.value!,
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
