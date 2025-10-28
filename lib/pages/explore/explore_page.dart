import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/model/driver_model.dart';
import '/dist/component_exports.dart';
import '/pages/driver/open_driver_tile.dart';
import '/controllers/open_driver_list_controller.dart';
import '/component/bohiba_appbar/explore_appbar.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ExplorePage extends GetView<OpenDriverListController> {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: ExploreAppBar(
        title: 'Explore',
        actions: [
          /*AppBarIconBox(
            onTap: () {
              showSearch(
                context: context,
                delegate: BohibaSearchDelegate<String>(
                  items: ['Bidyut', 'Amit'],
                  hintText: 'Search by trip name',
                  searchPredicate: (String item, String query) {
                    final q = query.toLowerCase();
                    return item.toString().toLowerCase().contains(q) ||
                        item.toString().toLowerCase().contains(q) ||
                        item.toString().toLowerCase().contains(q);
                  },
                  itemBuilder: (BuildContext context, String item) {
                    return GestureDetector(
                      onTap: () {
                        navigateState.pop();
                        // Navigate to profile
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color: bohibaTheme.cardColor,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item,
                              style: bohibaTheme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            icon: const Icon(EvaIcons.searchOutline),
          ),*/
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                navigateState.pushNamed(AppRoute.allSentReq);
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: ScreenUtils.height10,
                  left: ScreenUtils.height15,
                  right: ScreenUtils.height15,
                  bottom: ScreenUtils.height10,
                ),
                color: BohibaColors.transparent,
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
              child: SmartRefresher(
                controller: controller.refreshController,
                onRefresh: () async {
                  await controller.getAllOpenDriver(
                    refresh: true,
                    showLoading: false,
                  );
                  controller.refreshController.refreshCompleted();
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: ScreenUtils.height15,
                    right: ScreenUtils.height15,
                  ),
                  itemCount: controller.arrOpenDriver.length,
                  itemBuilder: (context, index) {
                    UserModel openDriver = controller.arrOpenDriver[index];
                    return OpenDriverTile(
                      openDriver: openDriver,
                      onTap: () {
                        navigateState
                            .pushNamed(AppRoute.openDriver,
                                arguments: openDriver)
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
            ),
          ],
        );
      }),
    );
  }
}
