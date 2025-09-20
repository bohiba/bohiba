import 'package:auto_size_text/auto_size_text.dart';
import '/component/screen_utils.dart';
import '/controllers/trip_controller.dart';
import '/dist/app_enums.dart';
import '/pages/trips/trip_menu.dart';
import '/theme/bohiba_theme.dart';
import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';

import 'package:flutter/material.dart';

class TripAppBar extends GetView<TripController>
    implements PreferredSizeWidget {
  final String title;

  const TripAppBar({
    super.key,
    this.title = "Title",
  });

  @override
  Widget build(BuildContext context) {
    NavigatorState navigate = Navigator.of(context);
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: SizedBox(
          width: ScreenUtils.width * 0.45,
          child: AutoSizeText(
            title,
            maxLines: 1,
            style: bohibaTheme.appBarTheme.titleTextStyle,
            overflowReplacement: MarqueeText(
              speed: 10,
              alwaysScroll: true,
              style: bohibaTheme.appBarTheme.titleTextStyle,
              text: TextSpan(
                text: title,
              ),
            ),
          ),
        ),
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios_new_rounded),
          onTap: () {
            navigate.pop(true);
          },
        ),
        actions: [
          TripMenu(
            allowedActions: [
              TripActionType.document,
              TripActionType.expense,
              TripActionType.payment,
              TripActionType.reassignment,
              TripActionType.more,
              TripActionType.edit,
              TripActionType.share,
              TripActionType.delete
            ],
            onActionComplete: {
              TripActionType.edit: (edit) async {
                if (edit != null && edit != false) {
                  controller.tripInfo.value = (await controller.getTripInfo(
                    methodType: MethodType.server,
                    tripInfo: controller.tripInfo.value,
                  ))!;
                }
              },
              TripActionType.expense: (expense) async {
                if (expense != null && expense != false) {
                  controller.tripInfo.value = (await controller.getTripInfo(
                    methodType: MethodType.server,
                    tripInfo: controller.tripInfo.value,
                  ))!;
                }
              },
              TripActionType.payment: (payment) async {
                if (payment != null && payment != false) {
                  controller.tripInfo.value = (await controller.getTripInfo(
                    methodType: MethodType.server,
                    tripInfo: controller.tripInfo.value,
                  ))!;
                }
              },
            },
            trip: controller.tripInfo.value,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
