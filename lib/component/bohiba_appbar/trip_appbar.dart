import 'package:auto_size_text/auto_size_text.dart';
import '/pages/widget/role_widget.dart';
import '/component/screen_utils.dart';
import '/controllers/trip_controller.dart';
import '../../dist/enums/app_enums.dart';
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
          RoleWidget(
            truckOwnerWidget: Visibility(
              visible: controller.tripInfo.value != null,
              child: TripMenu(
                allowedActions: [
                  TripActionType.edit,
                  TripActionType.document,
                  TripActionType.expense,
                  TripActionType.payment,
                  TripActionType.reassignment,
                  // TripActionType.share,
                  TripActionType.delete
                ],
                onActionComplete: {
                  TripActionType.edit: (edit) async {
                    if (edit != null && edit != false) {
                      await controller.getTripInfo(
                        methodType: MethodType.api,
                        id: controller.tripInfo.value!.id!,
                      );
                    }
                  },
                  TripActionType.document: (doc) async {
                    if (doc != null && doc != false) {
                      await controller.getTripInfo(
                        id: controller.tripInfo.value!.id!,
                      );
                    }
                  },
                  TripActionType.expense: (expense) async {
                    if (expense != null && expense != false) {
                      await controller.getTripInfo(
                        methodType: MethodType.api,
                        id: controller.tripInfo.value!.id!,
                      );
                    }
                  },
                  TripActionType.payment: (payment) async {
                    if (payment != null && payment != false) {
                      await controller.getTripInfo(
                        methodType: MethodType.api,
                        id: controller.tripInfo.value!.id!,
                      );
                    }
                  },
                  TripActionType.reassignment: (reAssign) async {
                    if (reAssign != null && reAssign != false) {
                      await controller.getTripInfo(
                        id: controller.tripInfo.value!.id!,
                      );
                    }
                  },
                  TripActionType.delete: (delete) async {
                    if (delete != null && delete > 0) {
                      navigate.pop(true);
                    }
                  }
                },
                trip: controller.tripInfo.value,
              ),
            ),
            driverWidget: TripMenu(
              trip: controller.tripInfo.value,
              allowedActions: [
                TripActionType.document,
                // TripActionType.share,
              ],
              onActionComplete: {
                TripActionType.document: (document) async {
                  if (document != null && document != false) {
                    await controller.getTripInfo(
                      id: controller.tripInfo.value!.id!,
                    );
                  }
                },
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
