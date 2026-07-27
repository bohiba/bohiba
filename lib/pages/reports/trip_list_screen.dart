import 'package:bohiba/component/bohiba_buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/component/app_skeleton_loader.dart';
import '/controllers/trip_report_controller.dart';
import '/dist/component_exports.dart';
import '/model/trip_report_model.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class TripListScreen extends GetView<TripReportController> {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Select trips',
        actions: [
          Obx(() {
            final count = controller.trips.length;
            if (count == 0) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: bohibaTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isSearching.value) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.width15,
                vertical: ScreenUtils.height10),
            child: AppSkeletonLoader(skeletonLength: 6),
          );
        }

        if (controller.searchError.value) {
          return _ErrorState(onRetry: controller.searchTrips);
        }

        if (controller.hasSearched.value && controller.trips.isEmpty) {
          return _EmptyState();
        }

        if (!controller.hasSearched.value) {
          return _InitialState();
        }

        return Column(
          children: [
            _SelectionBar(controller: controller),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.width15,
                    vertical: ScreenUtils.height8),
                itemCount: controller.trips.length,
                separatorBuilder: (_, __) => Gap(8.h),
                itemBuilder: (_, i) {
                  final trip = controller.trips[i];
                  return Obx(
                    () => TripSelectCard(
                      trip: trip,
                      isSelected: controller.selectedIds.contains(trip.id ?? 0),
                      onToggle: () => controller.toggleTrip(trip.id ?? 0),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (!controller.hasSearched.value || controller.trips.isEmpty) {
          return const SizedBox.shrink();
        }
        final count = controller.selectionCount;
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: bohibaTheme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: bohibaTheme.dividerColor)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (count > 0)
                  Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$count trip${count > 1 ? 's' : ''} selected',
                            style: bohibaTheme.textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        GestureDetector(
                          onTap: controller.deselectAll,
                          child: Text('Deselect all',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: bohibaTheme.primaryColor,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                PrimaryButton(
                  onPressed: count > 0
                      ? () {
                          Get.toNamed(AppRoute.tripReportGenerate);
                          controller.generatePdf();
                        }
                      : null,
                  label: count > 0
                      ? 'GENERATE PDF ($count TRIPS)'
                      : 'SELECT AT LEAST ONE TRIP',
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _SelectionBar extends StatelessWidget {
  final TripReportController controller;
  const _SelectionBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: bohibaTheme.dividerColor)),
      ),
      child: Obx(() {
        final allSelected = controller.allSelected;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              allSelected
                  ? 'All ${controller.trips.length} selected'
                  : '${controller.selectionCount} of ${controller.trips.length} selected',
              style: bohibaTheme.textTheme.bodySmall,
            ),
            GestureDetector(
              onTap:
                  allSelected ? controller.deselectAll : controller.selectAll,
              child: Text(
                allSelected ? 'Deselect all' : 'Select all',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: bohibaTheme.primaryColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class TripSelectCard extends StatelessWidget {
  final TripReportModel trip;
  final bool isSelected;
  final VoidCallback onToggle;

  const TripSelectCard({
    super.key,
    required this.trip,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final primary = bohibaTheme.primaryColor;
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.06) : null,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? primary : bohibaTheme.dividerColor,
            width: isSelected ? 1.2 : 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20.r,
              height: 20.r,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: isSelected ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: isSelected ? primary : BohibaColors.greyColor,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 13.r, color: Colors.white)
                  : null,
            ),
            Gap(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trip.tripCode ?? 'TRP-${trip.id}',
                          style: bohibaTheme.textTheme.titleSmall
                              ?.copyWith(fontSize: 13.sp),
                        ),
                      ),
                      _StatusChip(status: trip.tripStatus),
                    ],
                  ),
                  Gap(2.h),
                  if (trip.regdNumber != null || trip.transporter != null)
                    Text(
                      [
                        trip.regdNumber,
                        trip.transporter,
                      ].where((s) => s != null).join(' · '),
                      style: bohibaTheme.textTheme.labelLarge
                          ?.copyWith(fontSize: 12.sp),
                    ),
                  Gap(6.h),
                  if (trip.origin != null)
                    _MetaChip(
                      icon: Icons.flag_outlined,
                      label: trip.origin ?? '',
                    ),
                  Gap(4.h),
                  if (trip.destination != null)
                    _MetaChip(
                      icon: Icons.flag_outlined,
                      label: trip.destination ?? '',
                    ),
                  Gap(4.h),
                  if (trip.date != null)
                    _MetaChip(label: 'Date: ${_fmt(trip.date)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(String? raw) {
    if (raw == null) return '—';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return DateFormat('d MMM').format(dt);
  }
}

class _StatusChip extends StatelessWidget {
  final int? status;
  const _StatusChip({this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: BohibaColors.successColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        'Completed',
        style: TextStyle(
            fontSize: 10.sp,
            color: BohibaColors.successColor,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  const _MetaChip({this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: bohibaTheme.canvasColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: bohibaTheme.dividerColor,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 11.r, color: BohibaColors.greyColor),
          if (icon != null) Gap(5.w),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11.sp,
                color: bohibaTheme.textTheme.bodySmall?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_off_outlined,
                size: 52.r, color: BohibaColors.greyColor),
            Gap(12.h),
            Text('No trips found', style: bohibaTheme.textTheme.titleMedium),
            Gap(6.h),
            Text(
              'Try adjusting your filters or widening the date range.',
              style: bohibaTheme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            Gap(16.h),
            OutlinedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.tune),
              label: const Text('Modify filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: BohibaColors.warningColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: BohibaColors.warningColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 18.r, color: BohibaColors.warningColor),
                Gap(8.w),
                Expanded(
                  child: Text(
                    "Couldn't load trips. Please retry.",
                    style: bohibaTheme.textTheme.bodySmall
                        ?.copyWith(color: BohibaColors.warningColor),
                  ),
                ),
              ],
            ),
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.tune),
                  label: const Text('Edit filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InitialState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 48.r, color: BohibaColors.greyColor),
            Gap(12.h),
            Text('Search for trips', style: bohibaTheme.textTheme.titleMedium),
            Gap(6.h),
            Text('Apply filters and tap "Search trips" to continue.',
                style: bohibaTheme.textTheme.bodySmall,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
