import 'trip_tile.dart';

import '/routes/app_route.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';
import '/dist/component_exports.dart';
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

class _AllTripPageState extends State<AllTripPage>
    with SingleTickerProviderStateMixin {
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
                  items: controller.arrTrip,
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
                        navigatorState.pop();
                        Get.toNamed(AppRoute.trips, arguments: item)!
                            .then((onValue) async {
                          if (onValue) {
                            await controller.fetchTrips();
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
          PermissionWidget(
            permission: RolePermissionService.addTrips,
            child: AppBarIconBox(
              icon: const Icon(EvaIcons.plus),
              onTap: () {
                navigatorState.pushNamed(AppRoute.addTrip).then((value) async {
                  if (value != null) {
                    await controller.fetchTrips(refresh: true);
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
                      return filteredTrips.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No Trip Found, Press below to add trip.',
                                ),
                                TextButton(
                                  onPressed: () {
                                    navigatorState
                                        .pushNamed(AppRoute.addTrip)
                                        .then((value) async {
                                      if (value != null) {
                                        await controller.fetchTrips();
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
                                          await controller.fetchTrips();
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
