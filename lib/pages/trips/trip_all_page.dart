import 'trip_tile.dart';

import '/routes/app_route.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';

import '/dist/widget_exports.dart';
import '/dist/component_exports.dart';

import '/component/app_skeleton_loader.dart';

import '/pages/widget/role_widget.dart';
import '/pages/widget/permission_widget.dart';
import '/controllers/trip_all_controller.dart';
import '/services/role_permission_service.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class AllTripPage extends StatefulWidget {
  final bool showLeading;
  const AllTripPage({
    super.key,
    this.showLeading = true,
  });

  @override
  State<AllTripPage> createState() => _AllTripPageState();
}

class _AllTripPageState extends State<AllTripPage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final controller = Get.find<AllTripController>();

  final List<String> tabs = [
    'All',
    'In Transit',
    'Completed',
    'Unloading',
    'Delayed',
    'Cancelled',
    'On Hold',
    'Reassigned',
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final navigatorState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Trips',
        showLeading: widget.showLeading,
        actions: [
          AppBarIconBox(
            onTap: () {
              showSearch(
                context: context,
                delegate: BohibaSearchDelegate<TripModel>(
                  items: controller.arrTrip.value ?? [],
                  hintText: 'Search by driver, trip code, vehicle number',
                  searchPredicate: (TripModel item, String query) {
                    final q = query.toLowerCase();
                    final tripCode = item.tripCode?.toLowerCase() ?? '';
                    final truckNumber = item.truck?.regdNumber?.toLowerCase() ?? '';
                    final driverName = item.driver?.name?.toLowerCase() ?? '';
                    return tripCode.contains(q) || truckNumber.contains(q) || driverName.contains(q);
                  },
                  itemBuilder: (BuildContext context, TripModel item) {
                    return GestureDetector(
                      onTap: () {
                        navigatorState.pop();
                        Get.toNamed(AppRoute.trips, arguments: item)!.then((onValue) async {
                          if (onValue) {
                            await controller.getAllTrip();
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
                            Text(
                              item.tripCode ?? '',
                              style: bohibaTheme.textTheme.labelLarge,
                            ),
                            Text(
                              item.truck?.regdNumber ?? '',
                              style: bohibaTheme.textTheme.titleMedium,
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
          ),
          AppBarIconBox(
            onTapDown: (tapDownDetails) => showMenu(
              context: context,
              menuPadding: EdgeInsets.zero,
              elevation: 4,
              position: RelativeRect.fromLTRB(
                tapDownDetails.globalPosition.dx,
                tapDownDetails.globalPosition.dy,
                0,
                0,
              ),
              items: [
                PopupMenuItem(
                  padding: EdgeInsets.zero,
                  enabled: false,
                  child: FilterMenu(
                    status: true,
                    statusText: 'Trip Status',
                    statusHint: controller.tripStatus.first,
                    statusList: controller.tripStatus,
                  ),
                ),
              ],
            ),
            icon: Icon(EvaIcons.funnelOutline),
          ),
          // AppBarIconBox(
          //   onTapDown: (tapDownDetails) => showMenu(
          //     context: context,
          //     menuPadding: EdgeInsets.zero,
          //     elevation: 4,
          //     position: RelativeRect.fromLTRB(
          //       tapDownDetails.globalPosition.dx,
          //       tapDownDetails.globalPosition.dy,
          //       0,
          //       0,
          //     ),
          //     items: [
          //       PopupMenuItem(
          //         padding: EdgeInsets.zero,
          //         enabled: false,
          //         child: SortMenu(),
          //       ),
          //     ],
          //   ),
          //   icon: Icon(Icons.sort),
          // ),
          PermissionWidget(
            permission: RolePermissionService.addTrips,
            child: AppBarIconBox(
              icon: const Icon(EvaIcons.plus),
              onTap: () {
                navigatorState.pushNamed(AppRoute.addTrip).then((value) async {
                  if (value != null && value != false) {
                    await controller.getAllTrip();
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TabBar(
                controller: tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: List.generate(
                  tabs.length,
                  (index) {
                    return Tab(text: tabs[index]);
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: controller.convertToSnakeCase(tabs).map(
                    (status) {
                      final filteredTrips = controller.getTripsByStatus(status);
                      if (filteredTrips == null) {
                        return AppSkeletonLoader(
                          padding: EdgeInsets.only(top: ScreenUtils.height20),
                          skeletonLength: 3,
                        );
                      } else if (filteredTrips.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Trip Found',
                              style: bohibaTheme.textTheme.displaySmall,
                            ),
                            Text(
                              'No trip found, Press below to add trip.',
                              style: bohibaTheme.textTheme.titleMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                navigatorState.pushNamed(AppRoute.addTrip).then((value) async {
                                  if (value != null) {
                                    await controller.getAllTrip();
                                  }
                                });
                              },
                              child: RoleWidget(
                                truckOwnerWidget: Text('Add Trip'),
                              ),
                            )
                          ],
                        );
                      } else {
                        return ListView.builder(
                          // controller: controller.scrollController,
                          itemCount: (filteredTrips.length) + (controller.hasMore.value ? 1 : 0),
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
                                  navigatorState.pushNamed(AppRoute.trips, arguments: filteredTrips[index]).then((onValue) async {
                                    if (onValue != false) {
                                      await controller.getAllTrip();
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
                      }
                    },
                  ).toList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
