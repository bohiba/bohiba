import '../../dist/enums/app_enums.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/model/user_model.dart';
import '/component/screen_utils.dart';
import '/pages/driver/driver_tile.dart';
import '/controllers/home_controller.dart';
import '/component/app_skeleton_loader.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeDriverSection extends GetView<HomeController> {
  const HomeDriverSection({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return Obx(
      () {
        return Visibility(
          visible: controller.arrDriver.value?.isNotEmpty ?? false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
                child: Row(
                  children: [
                    Text(
                      'Driver',
                      style: bohibaTheme.textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        navigatorState
                            .pushNamed(AppRoute.allDriver)
                            .then((onValue) {
                          if (onValue != null && onValue == true) {
                            controller.getDriverList();
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenUtils.height5,
                        ),
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize:
                                bohibaTheme.textTheme.headlineSmall!.fontSize,
                            color: bohibaTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.arrTrip.value == null)
                AppSkeletonLoader(skeletonLength: 3)
              else
                Container(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      left: ScreenUtils.width15,
                      right: ScreenUtils.width15,
                      bottom: ScreenUtils.height25,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.arrDriver.value?.length ?? 0,
                    itemBuilder: (context, index) {
                      UserModel driverModel =
                          controller.arrDriver.value![index];
                      return DriverTile(
                        driver: driverModel,
                        allowedActions: [
                          ActionType.view,
                          ActionType.add,
                          ActionType.edit,
                          ActionType.other,
                        ],
                        onPressed: () {
                          navigatorState.pushNamed(
                            AppRoute.driver,
                            arguments: {
                              'driver_id': driverModel.id,
                            },
                          ).then(
                            (onValue) async {
                              if (onValue != null) {
                                await controller.getDriverList();
                                // controller.arrDriver.refresh();
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
