import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/model/truck_model.dart';

import 'truck_tile.dart';
import '/dist/enums/app_enums.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/dist/component_exports.dart';
import '/pages/widget/permission_widget.dart';
import '/controllers/truck_all_controller.dart';
import '/services/role_permission_service.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllTruckPage extends GetView<TruckAllController> {
  final bool showLeading;
  const AllTruckPage({super.key, this.showLeading = true});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navState = Navigator.of(context);

    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: "Trucks",
          showLeading: showLeading,
          popResult: controller.countUpdate > 0 ? true : false,
          actions: [
            PermissionWidget(
              permission: RolePermissionService.addTrucks,
              child: AppBarIconBox(
                icon: const FaIcon(FontAwesomeIcons.plus),
                onTap: () {
                  navState.pushNamed(AppRoute.addTruck).then((value) async {
                    if (value != null) {
                      await controller.getTruckList();
                    }
                  });
                },
              ),
            )
          ],
        ),
        body: SafeArea(
          child: SmartRefresher(
            controller: controller.refreshTruckList,
            onRefresh: () async => {
              await controller.getTruckList(
                  methodType: MethodType.api, resetList: true),
              controller.refreshTruckList.refreshCompleted(),
            },
            child: controller.arrTruck.value == null
                ? Center(
                    child: SizedBox(
                      width: ScreenUtils.width * 0.65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.strErrorTitle.value,
                            style: bohibaTheme.textTheme.displaySmall,
                          ),
                          Text(
                            controller.strErrorDes.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.bodySmall!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleSmall!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : (controller.arrTruck.value?.isEmpty ?? true)
                    ? SizedBox.shrink()
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          top: ScreenUtils.height10,
                          bottom: ScreenUtils.height5,
                          left: ScreenUtils.width15,
                          right: ScreenUtils.width15,
                        ),
                        itemCount: (controller.arrTruck.value?.length ?? 0),
                        itemBuilder: (context, index) {
                          if (controller.arrTruck.value != null) {
                            TruckModel truck =
                                controller.arrTruck.value![index];
                            return TruckTile(
                              truckInfo: truck,
                              allowedActions: [
                                ActionType.view,
                                ActionType.add,
                                ActionType.edit,
                                ActionType.other,
                                ActionType.sync,
                              ],
                              onActionComplete: {
                                ActionType.view: (onValue) {},
                                ActionType.add: (onValue) {},
                                ActionType.edit: (onValue) async {
                                  if (onValue != null) {
                                    controller.countUpdate++;
                                    await controller.getTruckList();
                                  }
                                },
                                ActionType.other: (onValue) {
                                  // Maintainance
                                },
                              },
                              onClick: () {
                                navState
                                    .pushNamed(
                                  AppRoute.truck,
                                  arguments: truck.regdNumber,
                                )
                                    .then(
                                  (onValue) async {
                                    if (onValue != null) {
                                      controller.countUpdate++;
                                      await controller.getTruckList();
                                    }
                                  },
                                );
                              },
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
          ),
        ),
      );
    });
  }
}
