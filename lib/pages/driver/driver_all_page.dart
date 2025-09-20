import '/theme/bohiba_theme.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/dist/app_enums.dart';

import '/model/driver_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/pages/driver/driver_tile.dart';
import '/routes/app_route.dart';
import '/dist/component_exports.dart';
import '/controllers/driver_all_controller.dart';

class DriverAllPage extends GetView<DriverAllController> {
  const DriverAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Drivers',
        actions: [
          AppBarIconBox(
            icon: const Icon(EvaIcons.plus),
            onTap: () {
              Get.toNamed(AppRoute.addDriver);
            },
          )
        ],
      ),
      body: Obx(
        () {
          return SmartRefresher(
            onRefresh: () async {
              await controller.refreshPage();
            },
            controller: controller.refreshList,
            child: controller.arrDriver.isEmpty
                ? Center(
                    child: SizedBox(
                      width: ScreenUtils.width * 0.65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Driver Found',
                            style: bohibaTheme.textTheme.displaySmall,
                          ),
                          Text(
                            'Add a driver to assign them to a truck and start trips quickly.',
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
                              navState.pushNamed(AppRoute.addDriver);
                            },
                            child: Text('Add New Driver'),
                          )
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.arrDriver.length > 3
                        ? 3
                        : controller.arrDriver.length,
                    padding: EdgeInsets.only(
                      top: ScreenUtils.height10,
                      bottom: ScreenUtils.height5,
                      left: ScreenUtils.width15,
                      right: ScreenUtils.width15,
                    ),
                    itemBuilder: (context, index) {
                      DriverModel driverObj = controller.arrDriver[index];
                      return DriverTile(
                        driver: driverObj,
                        allowedActions: [
                          ActionType.view,
                          ActionType.other,
                          ActionType.route,
                          ActionType.delete,
                        ],
                        onActionComplete: {
                          ActionType.delete: (value) async {
                            await controller.getDriverList();
                          },
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
