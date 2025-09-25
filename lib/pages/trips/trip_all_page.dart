import '/pages/widget/permission_widget.dart';
import '/services/role_permission_service.dart';

import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';
import 'package:get/get.dart';
import '/pages/trips/trip_tile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '/controllers/trip_all_controller.dart';
import '/dist/component_exports.dart';
import '/routes/app_route.dart';

class AllTripPage extends GetView<AllTripController> {
  const AllTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: 'All Trip',
        actions: [
          AppBarIconBox(
            onTap: () {
              showSearch(
                context: context,
                delegate: BohibaSearchDelegate<TripModel>(
                  items: controller.arrTrip.value,
                  hintText: 'Search by trip name',
                  searchPredicate: (TripModel item, String query) {
                    final q = query.toLowerCase();
                    return item.tripCode.toString().toLowerCase().contains(q) ||
                        item.truck!.regdNumber!
                            .toString()
                            .toLowerCase()
                            .contains(q) ||
                        item.driver!.name.toString().toLowerCase().contains(q);
                  },
                  itemBuilder: (BuildContext context, TripModel item) {
                    return GestureDetector(
                      onTap: () {
                        navigator.pop();
                        Get.toNamed(AppRoute.trips, arguments: item)!
                            .then((onValue) async {
                          if (onValue) {
                            await controller.getTripList();
                          }
                        });
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
                            Text(item.tripCode ?? ''),
                            Text(item.truck?.regdNumber ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            icon: const Icon(EvaIcons.searchOutline),
          ),
          PermissionWidget(
            permission: RolePermissionService.addTrips,
            child: AppBarIconBox(
              icon: const Icon(EvaIcons.plus),
              onTap: () {
                navigator.pushNamed(AppRoute.addTrip).then((value) async {
                  if (value != null) {
                    await controller.getTripList();
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TabBar(
            controller: controller.tabController,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: List.generate(
              controller.tabs.length,
              (index) {
                return Tab(text: controller.tabs[index]);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              return TabBarView(
                controller: controller.tabController,
                children: controller
                    .convertToSnakeCase(controller.tabs)
                    .map((status) {
                  final filteredTrips = controller.getTripsByStatus(status);
                  return filteredTrips.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Trip Found, Press below to add trip.',
                            ),
                            TextButton(
                              onPressed: () {
                                navigator
                                    .pushNamed(AppRoute.addTrip)
                                    .then((value) async {
                                  if (value != null) {
                                    await controller.getTripList();
                                  }
                                });
                              },
                              child: Text('Add Trip'),
                            )
                          ],
                        )
                      : ListView.builder(
                          controller: controller.scrollController,
                          itemCount: filteredTrips.length +
                              (controller.hasMore.value ? 1 : 0),
                          padding: EdgeInsets.only(
                            top: ScreenUtils.height20,
                            left: ScreenUtils.width15,
                            right: ScreenUtils.width15,
                          ),
                          itemBuilder: (context, index) {
                            if (index < filteredTrips.length) {
                              return TripTile(
                                tripInfo: filteredTrips[index],
                                onClick: () {
                                  Get.toNamed(AppRoute.trips,
                                          arguments: filteredTrips[index])!
                                      .then((onValue) async {
                                    if (onValue) {
                                      await controller.getTripList();
                                    }
                                  });
                                },
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
