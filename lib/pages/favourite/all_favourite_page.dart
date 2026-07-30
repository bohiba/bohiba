import '/dist/enums/app_enums.dart';
import '/dist/enums/enum_favourite_type.dart';
import '/controllers/home_controller.dart';
import '/dist/component_exports.dart';
import '/model/company_model.dart';
import '/model/user_fav_model.dart';
import '/model/user_model.dart';
import '/model/truck_model.dart';
import '/pages/driver/driver_tile.dart';
import '../company/company_tile.dart';
import '/pages/truck/truck_tile.dart';
import '/routes/app_route.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AllFavouritePage extends GetView<HomeController> {
  const AllFavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        showLeading: false,
        title: "Favourite",
      ),
      body: Obx(() {
        final arrFavList = controller.arrFavList.value ?? [];
        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshFavouriteList();
          },
          child: (arrFavList.isEmpty)
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: Text("No Favourites"),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.width15,
                    vertical: ScreenUtils.height5,
                  ),
                  itemCount: arrFavList.length,
                  itemBuilder: (context, index) {
                    FavouriteModel favObj = arrFavList[index];

                    if (favObj.type == EnumFavouriteType.driver.index) {
                      return DriverTile(
                        driver: UserModel(
                          id: favObj.driverId ?? favObj.userDriverId,
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
                            await controller.refreshFavouriteList();
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
                              'truck_id': favObj.userTruckId,
                            },
                          )?.then(
                            (onValue) async {
                              if (onValue != null) {
                                await controller.refreshFavouriteList();
                                controller.arrFavList.refresh();
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

                    return Container();
                  },
                ),
        );
      }),
    );
  }
}
