import '/theme/bohiba_theme.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../model/user_model.dart';
import '/pages/driver/driver_tile.dart';
import '/routes/app_route.dart';
import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/controllers/driver_all_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class DriverAllPage extends GetView<DriverAllController> {
  const DriverAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navState = Navigator.of(context);

    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: 'Drivers',
          actions: [
            AppBarIconBox(
              icon: const Icon(EvaIcons.plus),
              onTap: () {
                navState.pushNamed(AppRoute.addDriver).then((onValue) async {
                  if (onValue != null && onValue != false) {
                    await controller.getDriverList();
                  }
                });
              },
            )
          ],
        ),
        body: SmartRefresher(
          onRefresh: () async {
            await controller.getDriverList(
              type: MethodType.api,
              resetList: true,
            );
            controller.refreshList.refreshCompleted();
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
                          controller.strErrorTitle.value,
                          style: bohibaTheme.textTheme.displaySmall,
                        ),
                        Text(
                          controller.strErrorDes.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                            color: bohibaTheme.textTheme.titleSmall!.color,
                          ),
                        ),
                        if (controller.strErrorDes.isEmpty)
                          TextButton(
                            onPressed: () {
                              navState.pushNamed(AppRoute.addDriver).then((onValue) async {
                                if (onValue != null) {
                                  await controller.getDriverList(
                                    type: MethodType.api,
                                  );
                                }
                              });
                            },
                            child: Text('Add New Driver'),
                          )
                        else
                          SizedBox.shrink()
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: controller.arrDriver.length > 3 ? 3 : controller.arrDriver.length,
                  padding: EdgeInsets.only(
                    top: ScreenUtils.height10,
                    bottom: ScreenUtils.height5,
                    left: ScreenUtils.width15,
                    right: ScreenUtils.width15,
                  ),
                  itemBuilder: (context, index) {
                    UserModel driver = controller.arrDriver[index];
                    return DriverTile(
                      driver: driver,
                      allowedActions: [ActionType.view, ActionType.share, ActionType.other],
                      onPressed: () {
                        navState.pushNamed(AppRoute.driver, arguments: driver.id).then(
                          (onValue) async {
                            if (onValue != null) {
                              await controller.getDriverList();
                            }
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      );
    });
  }
}
