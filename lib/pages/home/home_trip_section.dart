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
    return Visibility(
      visible: controller.arrOngoingTrip.isNotEmpty,
      child: Column(
        children: [
          // Home WishList Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
            child: Row(
              children: [
                Text(
                  "Ongoing Trips",
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
            child: Obx(() {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.arrOngoingTrip.length,
                itemBuilder: (context, index) {
                  return TripTile(tripInfo: controller.arrOngoingTrip[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
