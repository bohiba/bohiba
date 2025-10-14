import '/routes/app_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/theme/bohiba_theme.dart';
import '/pages/driver/open_driver_tile.dart';
import '/model/driver_model.dart';
import '/controllers/open_driver_list_controller.dart';
import 'package:get/get.dart';

import '/dist/component_exports.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '/component/bohiba_appbar/explore_appbar.dart';

class ExplorePage extends GetView<OpenDriverListController> {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: ExploreAppBar(
        title: 'Explore',
        actions: [
          AppBarIconBox(
            onTap: () {},
            icon: Icon(EvaIcons.searchOutline),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.height10,
                left: ScreenUtils.height15,
                right: ScreenUtils.height15,
                bottom: ScreenUtils.height10,
              ),
              child: GestureDetector(
                onTap: () {
                  navigateState.pushNamed(AppRoute.allSentReq);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: ScreenUtils.height10,
                    bottom: ScreenUtils.height10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sent Connect Request',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodyLarge!.fontWeight,
                          color: bohibaTheme.textTheme.bodyLarge!.color,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: ScreenUtils.height15,
                  right: ScreenUtils.height15,
                  top: ScreenUtils.height10,
                ),
                itemCount: controller.arrOpenDriver.length,
                itemBuilder: (context, index) {
                  DriverModel openDriver = controller.arrOpenDriver[index];
                  return OpenDriverTile(
                    openDriver: openDriver,
                    onTap: () {
                      navigateState
                          .pushNamed(AppRoute.openDriver, arguments: openDriver)
                          .then((onValue) async {
                        if (onValue != null && onValue != false) {
                          await controller.getAllOpenDriver();
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
