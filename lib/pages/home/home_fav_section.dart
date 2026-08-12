import '/dist/enums/enum_favourite_type.dart';
import '/model/company_model.dart';
import '/model/user_fav_model.dart';

import '../company/company_tile.dart';
import '/pages/truck/truck_tile.dart';
import '/pages/driver/driver_tile.dart';

import '../../dist/enums/app_enums.dart';
import '/controllers/home_controller.dart';
import '/component/bohiba_navbar/bohiba_navbar.dart';

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
        visible: controller.arrFavList.value?.isNotEmpty ?? false,
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
                    style: bohibaTheme.textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context
                        .findAncestorStateOfType<BohibaNavBarState>()
                        ?.switchTab(1),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtils.height5,
                      ),
                      child: Text(
                        "See All",
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

            // Home WishList Section
            Container(
              padding: EdgeInsets.only(bottom: ScreenUtils.height15),
              alignment: Alignment.center,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: ScreenUtils.width15,
                  right: ScreenUtils.width15,
                  bottom: ScreenUtils.height5,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: (controller.arrFavList.value?.length ?? 0) > 3
                    ? 3
                    : (controller.arrFavList.value?.length ?? 0),
                itemBuilder: (context, index) {
                  FavouriteModel favObj = controller.arrFavList.value![index];

                  if (favObj.type == EnumFavouriteType.driver.index) {
                    return DriverTile(
                      driver: UserModel(
                        id: favObj.userDriverId,
                        isFav: favObj.isFav ?? false,
                        profile: UserProfile(
                          name: favObj.name,
                          image: favObj.image,
                        ),
                      ),
                      onPressed: () {
                        navigatorState.pushNamed(
                          AppRoute.driver,
                          arguments: {
                            'driver_id': favObj.userDriverId,
                          },
                        ).then((onValue) async {
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

                  if (favObj.type == EnumFavouriteType.truck.index) {
                    return TruckTile(
                      truckInfo: TruckModel(
                        id: favObj.truckId ?? favObj.userTruckId,
                        isFav: (favObj.isFav ?? false),
                        regdNumber: favObj.name,
                        truckImage: favObj.image,
                      ),
                      allowedActions: [
                        ActionType.view,
                        ActionType.add,
                        ActionType.edit,
                        ActionType.other,
                      ],
                      onClick: () {
                        Get.toNamed(
                          AppRoute.truck,
                          arguments: {
                            "truck_id": favObj.userTruckId,
                          },
                        )?.then(
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

                  if (favObj.type == EnumFavouriteType.mines.index) {
                    return CompanyTile(
                      minesInfo: CompanyModel(
                        id: favObj.minesId,
                        name: favObj.name,
                        logo: favObj.image,
                        nameCode: favObj.nameCode,
                      ),
                    );
                  }

                  if (favObj.type == EnumFavouriteType.unknown.index) {
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
