import '/pages/widget/permission_widget.dart';
import '/services/role_permission_service.dart';

import '/theme/bohiba_theme.dart';

import '/dist/app_enums.dart';
import '/controllers/truck_all_controller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'truck_tile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '/routes/app_route.dart';
import '/dist/component_exports.dart';

class AllTruckPage extends GetView<TruckAllController> {
  const AllTruckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: "Trucks",
        actions: [
          PermissionWidget(
            permission: RolePermissionService.addTrucks,
            child: AppBarIconBox(
              icon: const Icon(EvaIcons.plus),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AppRoute.addTruck)
                    .then((value) async {
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
        child: Obx(() {
          return SmartRefresher(
            controller: controller.refreshList,
            onRefresh: () async => await controller.onRefreshTruckList(),
            child: controller.arrTruck.isEmpty
                ? Center(
                    child: SizedBox(
                      width: ScreenUtils.width * 0.65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Truck Found',
                            style: bohibaTheme.textTheme.displaySmall,
                          ),
                          Text(
                            'Add a truck and assign them driver and start trips quickly.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.bodySmall!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleSmall!.color,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              navState
                                  .pushNamed(AppRoute.addTruck)
                                  .then((onValue) async {
                                if (onValue != null) {
                                  await controller.getTruckList();
                                }
                              });
                            },
                            child: Text('Add New Truck'),
                          )
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(
                      top: ScreenUtils.height10,
                      bottom: ScreenUtils.height5,
                      left: ScreenUtils.width15,
                      right: ScreenUtils.width15,
                    ),
                    itemCount: controller.arrTruck.length,
                    itemBuilder: (context, index) {
                      return TruckTile(
                        truckInfo: controller.arrTruck[index],
                        allowedActions: [
                          ActionType.view,
                          ActionType.add,
                          ActionType.edit,
                          ActionType.other,
                          ActionType.delete,
                        ],
                        onActionComplete: {
                          ActionType.view: (onValue) {},
                          ActionType.add: (onValue) {},
                          ActionType.edit: (onValue) async {
                            if (onValue != null) {
                              await controller.getTruckList();
                            }
                          },
                          ActionType.other: (onValue) {
                            // Maintainance
                          },
                          ActionType.delete: (onValue) async {
                            if (onValue != null) {
                              await controller.getTruckList();
                            }
                          },
                        },
                        onClick: () {
                          Get.toNamed(AppRoute.truck,
                                  arguments: controller.arrTruck[index].id)
                              ?.then(
                            (onValue) async {
                              if (onValue != null) {
                                await controller.getTruckList();
                                controller.arrTruck.refresh();
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
          );
        }),
      ),
    );
  }
}
