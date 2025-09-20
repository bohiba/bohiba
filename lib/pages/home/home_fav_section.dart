import '/pages/mines/mines_tile.dart';
import '/pages/truck/truck_tile.dart';

import '/controllers/home_controller.dart';
import '/controllers/truck_all_controller.dart';
import '/dist/app_enums.dart';
import '/model/driver_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/pages/trips/trip_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/pages/driver/driver_tile.dart';

import '/routes/app_route.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';

class HomeFavListSection extends GetView<HomeController> {
  const HomeFavListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: controller.arrFav.isNotEmpty,
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
                  InkWell(
                    borderRadius: BorderRadius.circular(ScreenUtils.width5),
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoute.favList,
                      arguments: {'fav': controller.arrFav},
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtils.height5,
                      ),
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize:
                              bohibaTheme.textTheme.headlineMedium!.fontSize,
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
                itemCount:
                    controller.arrFav.length > 3 ? 3 : controller.arrFav.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> favObj = controller.arrFav[index];

                  if (favObj.containsKey('license_detail')) {
                    return DriverTile(
                      driver: DriverModel.fromJson(favObj),
                      allowedActions: [
                        ActionType.view,
                        ActionType.add,
                        ActionType.other,
                        ActionType.route,
                      ],
                    );
                  }

                  if (favObj.containsKey('registration')) {
                    Get.put(TruckAllController());
                    return TruckTile(
                      truckInfo: TruckModel.fromJson(favObj),
                      allowedActions: [
                        ActionType.view,
                        ActionType.add,
                        ActionType.edit,
                        ActionType.other,
                      ],
                      onClick: () {
                        Get.toNamed(AppRoute.truck,
                                arguments: TruckModel.fromJson(favObj).id)
                            ?.then(
                          (onValue) async {
                            if (onValue != null) {
                              await controller.getTruckList();
                              await controller.getUserFavList();
                              controller.arrTrucks.refresh();
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
                    return TripTile(tripInfo: TripModel.fromJson(favObj));
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
