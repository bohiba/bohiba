import '/component/app_skeleton_loader.dart';
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
    final NavigatorState navigatorState = Navigator.of(context);
    return Obx(() {
      if (controller.arrTruck.value?.isEmpty ?? true) {
        return SizedBox.shrink();
      } else {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.width15,
              ),
              child: Row(
                children: [
                  Text(
                    'Truck',
                    style: bohibaTheme.textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      navigatorState.pushNamed(AppRoute.allTruck);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtils.height5,
                      ),
                      child: Text(
                        'See All',
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
            if (controller.arrTrip.value == null)
              AppSkeletonLoader(skeletonLength: 3)
            else
              Container(
                alignment: Alignment.center,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: ScreenUtils.width15,
                    right: ScreenUtils.width15,
                    bottom: ScreenUtils.height15,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: (controller.arrTruck.value?.length ?? 0) > 3 ? 3 : controller.arrTruck.value?.length ?? 0,
                  itemBuilder: (context, index) {
                    if (controller.arrTruck.value != null) {
                      TruckModel truckModel = controller.arrTruck.value![index];
                      return TruckTile(
                          truckInfo: truckModel,
                          allowedActions: [
                            ActionType.view,
                            ActionType.add,
                            ActionType.edit,
                            ActionType.other,
                          ],
                          onClick: () {
                            navigatorState
                                .pushNamed(
                              AppRoute.truck,
                              arguments: truckModel.regdNumber,
                            )
                                .then((onValue) async {
                              if (onValue != null) await controller.getTruckList();
                            });
                          });
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              )
          ],
        );
      }
    });
  }
}
