import '/pages/mines/mines_tile.dart';
import '/pages/truck/truck_tile.dart';
import '/pages/driver/driver_tile.dart';

import '/dist/app_enums.dart';
import '/controllers/home_controller.dart';

import '/model/user_model.dart';
import '/model/truck_model.dart';

import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeFavListSection extends GetView<HomeController> {
  const HomeFavListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return Obx(() {
      return Visibility(
        visible: controller.arrFavList.isNotEmpty,
        child: Column(
          children: [
            // Home WishList Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.width15,
              ),
              child: Row(
                children: [
                  Text(
                    "Favourite",
                    style: bohibaTheme.textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => navigatorState.pushNamed(
                      AppRoute.favList,
                      arguments: {'fav': controller.arrFavList},
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtils.height5,
                      ),
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                          color: bohibaTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Home WishList Section
            Container(
              padding: EdgeInsets.only(bottom: ScreenUtils.height25),
              alignment: Alignment.center,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: ScreenUtils.width15,
                  right: ScreenUtils.width15,
                  bottom: ScreenUtils.height5,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.arrFavList.length > 3 ? 3 : controller.arrFavList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> favObj = controller.arrFavList[index];

                  if (favObj.containsKey('license_detail')) {
                    return DriverTile(
                      driver: UserModel.fromJson(favObj),
                      onPressed: () {
                        navigatorState.pushNamed(AppRoute.driver, arguments: favObj['id']).then((onValue) async {
                          await controller.getDriverList();
                        });
                      },
                      allowedActions: [
                        ActionType.view,
                        ActionType.add,
                        ActionType.other,
                        ActionType.route,
                      ],
                    );
                  }

                  if (favObj.containsKey('registration')) {
                    return TruckTile(
                      truckInfo: TruckModel.fromDB(favObj),
                      allowedActions: [
                        ActionType.view,
                        ActionType.add,
                        ActionType.edit,
                        ActionType.other,
                      ],
                      onClick: () {
                        Get.toNamed(AppRoute.truck, arguments: TruckModel.fromDB(favObj).id)?.then(
                          (onValue) async {
                            if (onValue != null) {
                              await controller.getTruckList();
                              controller.arrTruck.refresh();
                            }
                          },
                        );
                      },
                    );
                  }

                  if (favObj.containsKey('mine_name')) {
                    return CompanyTile(
                      minesInfo: favObj,
                    );
                  }

                  if (favObj.containsKey('trip_code')) {
                    return SizedBox.fromSize();
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
