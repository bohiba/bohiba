import '/dist/enums/app_enums.dart';
import '/dist/enums/enum_favourite_type.dart';
import '/controllers/home_controller.dart';
import '/dist/component_exports.dart';
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
        if (arrFavList.isEmpty) {
          return const Center(child: Text("No Favourites"));
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.width15,
            vertical: ScreenUtils.height5,
          ),
          itemCount: arrFavList.length,
          itemBuilder: (context, index) {
            FavouriteModel favObj = arrFavList[index];

            if (favObj.type == EnumFavouriteType.driver.name) {
              return DriverTile(
                driver: UserModel(
                  id: favObj.driverId ?? favObj.userDriverId,
                  isFav: (favObj.isFav ?? false) ? 1 : 0,
                  profile: UserProfile(
                    name: favObj.name,
                    image: favObj.image,
                  ),
                ),
                onPressed: () {
                  navigatorState
                      .pushNamed(AppRoute.driver,
                          arguments: favObj.driverId ?? favObj.userDriverId)
                      .then((onValue) async {
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

            if (favObj.type == EnumFavouriteType.truck.name) {
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
                  Get.toNamed(AppRoute.truck,
                          arguments: favObj.truckId ?? favObj.userTruckId)
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
            }

            if (favObj.type == EnumFavouriteType.mines.name) {
              return CompanyTile(
                minesInfo: {
                  'mine_name': favObj.name ?? '',
                  'location': '',
                },
              );
            }

            return Container();
          },
        );
      }),
    );
  }
}
