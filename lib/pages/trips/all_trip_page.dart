import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'trip_tile.dart';

import '/routes/app_route.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';

import '/dist/widget_exports.dart';
import '/dist/enums/app_enums.dart';
import '/dist/component_exports.dart';
import '/extensions/ext_trip_status.dart';
import '/component/app_skeleton_loader.dart';
import '/component/bohiba_buttons/utility_action_button.dart';

import '/pages/widget/filter_menu.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/permission_widget.dart';
import '/controllers/all_trip_controller.dart';
import '/services/role_permission_service.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AllTripPage extends StatefulWidget {
  final bool showLeading;
  const AllTripPage({
    super.key,
    this.showLeading = true,
  });

  @override
  State<AllTripPage> createState() => _AllTripPageState();
}

class _AllTripPageState extends State<AllTripPage> {
  final controller = Get.find<AllTripController>();

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
                    final truckNumber =
                        item.truck?.regdNumber?.toLowerCase() ?? '';
                    final driverName = item.driver?.name?.toLowerCase() ?? '';
                    return tripCode.contains(q) ||
                        truckNumber.contains(q) ||
                        driverName.contains(q);
                  },
                  itemBuilder: (BuildContext context, TripModel item) {
                    return GestureDetector(
                      onTap: () {
                        navigatorState.pop();
                        Get.toNamed(AppRoute.trips, arguments: item)!
                            .then((onValue) async {
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
            icon: const Icon(Icons.search_sharp, size: 22),
          ),
          PermissionWidget(
            permission: RolePermissionService.addTrips,
            child: AppBarIconBox(
              icon: Icon(RemixIcons.add_fill),
              onTap: () {
                navigatorState.pushNamed(AppRoute.addTrip).then(
                  (value) async {
                    if (value != null && value != false) {
                      await controller.getAllTrip();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final source = controller.arrTrip.value;
          final displayed = controller.displayedTrips;

          return Column(
            children: [
              _FilterActionRow(controller: controller),
              Expanded(
                child: source == null
                    ? AppSkeletonLoader(
                        padding: EdgeInsets.only(top: ScreenUtils.height20),
                        skeletonLength: 10,
                      )
                    : displayed.isEmpty
                        ? _EmptyState(
                            noTripsAtAll: source.isEmpty,
                            hasActiveFilter: controller.hasActiveFilter,
                            onAdd: () => navigatorState
                                .pushNamed(AppRoute.addTrip)
                                .then((value) async {
                              if (value != null) {
                                await controller.fetchTrips(refresh: true);
                              }
                            }),
                            onClearFilter: controller.clearFilters,
                          )
                        : SmartRefresher(
                            controller: controller.refreshController,
                            onRefresh: () async {
                              await controller.fetchTrips(refresh: true);
                              controller.refreshController.refreshCompleted();
                            },
                            child: ListView.separated(
                              controller: controller.scrollController,
                              itemCount: displayed.length +
                                  (controller.isLoading.value ? 1 : 0),
                              padding: EdgeInsets.only(
                                top: ScreenUtils.height5,
                                left: ScreenUtils.width15,
                                right: ScreenUtils.width15,
                                bottom: 16.h,
                              ),
                              separatorBuilder: (_, __) => Gap(2.h),
                              itemBuilder: (context, index) {
                                if (index < displayed.length) {
                                  return TripTile(
                                    tripInfo: displayed[index],
                                    onClick: () {
                                      navigatorState
                                          .pushNamed(AppRoute.trips,
                                              arguments: displayed[index])
                                          .then((onValue) async {
                                        if (onValue != false) {
                                          await controller.getAllTrip(
                                              type: MethodType.local,
                                              refreshTrip: true);
                                        }
                                      });
                                    },
                                  );
                                }
                                return AppSkeletonLoader(
                                  skeletonLength: 2,
                                );
                              },
                            ),
                          ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter action row — trip count + clear badge + FilterMenu popup trigger
// ---------------------------------------------------------------------------

class _FilterActionRow extends StatelessWidget {
  final AllTripController controller;
  const _FilterActionRow({required this.controller});

  static List<String> get _statusNames =>
      AllTripController.allStatusCodes.map((c) => c.tripStatusName).toList();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasFilter = controller.hasActiveFilter;
      final count = controller.displayedTrips.length;

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width15,
          vertical: ScreenUtils.height5,
        ),
        child: Row(
          children: [
            Text(
              '$count Trip${count == 1 ? '' : 's'}',
              style: bohibaTheme.textTheme.bodyMedium,
            ),
            if (hasFilter) ...[
              Gap(8.w),
              GestureDetector(
                onTap: controller.clearFilters,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(RemixIcons.close_circle_line,
                        size: 14.sp, color: bohibaTheme.colorScheme.tertiary),
                    Gap(2.w),
                    Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: bohibaTheme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            UtilityActionButton(
              icon: Remix.equalizer_2_line,
              buttonName: 'Filter',
              onPanDown: (details) => showMenu(
                context: context,
                menuPadding: EdgeInsets.zero,
                elevation: 4,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx - ScreenUtils.width * 0.5,
                  details.globalPosition.dy + ScreenUtils.height * 0.02,
                  details.globalPosition.dx,
                  0,
                ),
                items: [
                  PopupMenuItem(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    enabled: false,
                    child: SizedBox(
                      width: ScreenUtils.width * 0.95,
                      child: FilterMenu(
                        dateRange: true,
                        status: true,
                        statusText: 'Trip Status',
                        statusHint: 'Select trip status',
                        statusList: _statusNames,
                        onApply: controller.applyFilterMenu,
                        onReset: controller.clearFilters,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Empty state — distinguishes "no trips" from "filter removed all results"
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final bool noTripsAtAll;
  final bool hasActiveFilter;
  final VoidCallback onAdd;
  final VoidCallback onClearFilter;

  const _EmptyState({
    required this.noTripsAtAll,
    required this.hasActiveFilter,
    required this.onAdd,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasActiveFilter
                ? RemixIcons.filter_off_line
                : RemixIcons.truck_line,
            size: 48.sp,
            color: bohibaTheme.textTheme.titleMedium!.color,
          ),
          Gap(12.h),
          Text(
            hasActiveFilter
                ? 'No trips match the selected filters'
                : 'No Trips Found',
            style: bohibaTheme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Gap(4.h),
          Text(
            hasActiveFilter
                ? 'Try adjusting or clearing your filters.'
                : 'Press below to add your first trip.',
            style: bohibaTheme.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          Gap(16.h),
          if (hasActiveFilter)
            TextButton.icon(
              label: Text('Clear Filters'),
              icon: Icon(RemixIcons.close_line, size: 16.sp),
              onPressed: onClearFilter,
            )
          else
            RoleWidget(
              truckOwnerWidget: TextButton(
                onPressed: onAdd,
                child: const Text('Add Trip'),
              ),
            ),
        ],
      ),
    );
  }
}
