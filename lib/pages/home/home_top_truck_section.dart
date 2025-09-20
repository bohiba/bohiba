import '/controllers/home_controller.dart';
import '/dist/app_enums.dart';
import '/model/truck_model.dart';
import '/pages/truck/truck_tile.dart';
import '/routes/app_route.dart';
import 'package:get/get.dart';

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class HomeTopTruck extends GetView<HomeController> {
  const HomeTopTruck({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: controller.arrTrucks.isNotEmpty,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.width15,
              ),
              child: Row(
                children: [
                  Text(
                    'Your Top Truck\'s',
                    style: bohibaTheme.textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(ScreenUtils.width5),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtils.height5,
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontSize:
                              bohibaTheme.textTheme.headlineMedium!.fontSize,
                          color: BohibaColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top Tipper's List
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtils.height25,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Obx(() {
                  return ListView.builder(
                      padding: EdgeInsets.only(
                        left: ScreenUtils.width15,
                        right: ScreenUtils.width15,
                        bottom: ScreenUtils.height5,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.arrTrucks.length,
                      itemBuilder: (context, index) {
                        TruckModel topVehicleObj = controller.arrTrucks[index];
                        return TruckTile(
                          truckInfo: topVehicleObj,
                          allowedActions: [
                            ActionType.view,
                            ActionType.add,
                            ActionType.edit,
                            ActionType.other,
                          ],
                          onClick: () {
                            Get.toNamed(AppRoute.truck,
                                    arguments: topVehicleObj.id)
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
                      });
                }),
              ),
            )
          ],
        ),
      );
    });
  }
}
