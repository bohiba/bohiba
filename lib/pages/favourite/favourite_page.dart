import 'package:get/get.dart';

import '/controllers/fav_controller.dart';
import 'package:flutter/material.dart';
import '/component/bohiba_appbar/fav_appbar.dart';

class FavouritePage extends GetView<FavController> {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tabs.length,
      child: Scaffold(
        appBar: FavouriteAppbar(title: "Favourite"),
        body: Column(
          children: [
            /*TabBar(
              controller: controller.marketTabController,
              // isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: List.generate(
                controller.tabs.length,
                (index) {
                  return Tab(text: controller.tabs[index]);
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: controller.marketTabController,
                children: List.generate(
                  controller.tabs.length,
                  (index) {
                    // final filtered = controller.filterFavList(controller.tabs[index]);
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filtered.length > 3 ? 3 : filtered.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> favObj = filtered[index];

                        if (favObj.containsKey('license_detail')) {
                          return DriverTile(
                            driver: DriverModel.fromJson(favObj),
                            allowedActions: [
                              ActionType.view,
                              ActionType.other,
                              ActionType.route,
                              ActionType.delete,
                            ],
                          );
                        }

                        if (favObj.containsKey('registration')) {
                          return TruckTile(
                            truckInfo: TruckModel.fromJson(favObj),
                            allowedActions: [
                              ActionType.view,
                              ActionType.add,
                              ActionType.edit,
                              ActionType.other,
                            ],
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
                    );
                  },
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
