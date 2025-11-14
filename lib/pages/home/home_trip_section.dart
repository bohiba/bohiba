import 'package:bohiba/component/app_skeleton_loader.dart';

import '/routes/app_route.dart';

import '/controllers/home_controller.dart';
import 'package:get/get.dart';

import '/component/screen_utils.dart';
import '/pages/trips/trip_tile.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class HomeTripSection extends GetView<HomeController> {
  const HomeTripSection({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return Obx(() {
      return Visibility(
        visible: controller.arrTrip.value?.isNotEmpty ?? true,
        child: Column(
          children: [
            // Home WishList Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
              child: Row(
                children: [
                  Text(
                    "Trips",
                    style: bohibaTheme.textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  if (controller.arrTrip.value?.isNotEmpty ?? true)
                    GestureDetector(
                      onTap: () {
                        navigatorState.pushNamed(AppRoute.allTrip);
                      },
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
                    )
                  else
                    SizedBox.shrink()
                ],
              ),
            ),

            // Home WishList Section
            if (controller.arrTrip.value == null)
              AppSkeletonLoader(skeletonLength: 3)
            else
              Container(
                alignment: Alignment.center,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: ScreenUtils.width15,
                    right: ScreenUtils.width15,
                    bottom: ScreenUtils.height15,
                  ),
                  shrinkWrap: true,
                  itemCount: (controller.arrTrip.value?.length ?? 0) >= 3
                      ? 3
                      : controller.arrTrip.value?.length ?? 0,
                  itemBuilder: (context, index) {
                    return TripTile(
                      tripInfo: controller.arrTrip.value![index],
                      onClick: () {
                        navigatorState.pushNamed(
                          AppRoute.trips,
                          arguments: controller.arrTrip.value![index],
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      );
    });
  }
}
