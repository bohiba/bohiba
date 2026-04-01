import '/model/truck_model.dart';
import '/pages/truck/add_truck_component/truck_menu.dart';
import '/component/screen_utils.dart';
import '../../dist/enums/app_enums.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/truck_controller.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TruckAppbar extends GetView<TruckController> implements PreferredSizeWidget {
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
          /*Obx(
            () {
              return AppBarIconBox(
                onTap: () async => await controller
                    .handleFav(
                  assetId: controller.truckModel.value.id!,
                  truckModel: controller.truckModel.value,
                )
                    .then(
                  (onValue) async {
                    await controller.getTruckInfo(
                      id: controller.truckModel.value.id!.toString(),
                    );
                    controller.truckModel.refresh();
                    GlobalService.printHandler(
                        'Is marked fav: ${controller.truckModel.value.isFav}');
                  },
                ),
                icon: controller.truckModel.value.isFav == true
                    ? Icon(
                        Icons.favorite_rounded,
                        color: BohibaColors.warningColor,
                      )
                    : Icon(Remix.heart_3_line),
              );
            },
          ),*/
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
                    truckFetchValue: controller.truckModel.value!.regdNumber!,
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
