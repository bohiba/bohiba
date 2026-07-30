import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/pages/widget/required_label.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/component/bohiba_dropdown/app_search_dropdown_button.dart';
import '/controllers/trip_report_controller.dart';
import '/dist/component_exports.dart';
import '/model/company_model.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class TripFilterScreen extends GetView<TripReportController> {
  const TripFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: 'Filter Trips',
          actions: [
            TextButton(
              onPressed: controller.resetFilters,
              child: Text(
                'Reset',
                style:
                    TextStyle(color: bohibaTheme.primaryColor, fontSize: 13.sp),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.width15, vertical: ScreenUtils.height10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequiredLabel(label: 'Transport', required: true),
              AppDropdownSearch<CompanyModel>(
                hint: 'Search transporter...',
                menuController: controller.transporterController,
                items: controller.transporterSearchResults.toList(),
                initialValue: controller.selectedTransporter.value,
                searchState: controller.transporterSearchState.value,
                labelBuilder: (c) => c.name ?? '',
                onSearchChanged: controller.onTransporterQueryChanged,
                onChanged: controller.onTransporterSelected,
              ),

              // ── Mine (origin) ─────────────────────────────────────────
              RequiredLabel(label: 'Mine (Origin)'),
              AppDropdownSearch<CompanyModel>(
                hint: 'Search mine…',
                menuController: controller.mineController,
                items: controller.mineSearchResults.toList(),
                initialValue: controller.selectedMine.value,
                searchState: controller.mineSearchState.value,
                labelBuilder: (c) => c.name ?? '',
                onSearchChanged: controller.onMineQueryChanged,
                onChanged: controller.onMineSelected,
              ),

              // ── Plant (destination) ───────────────────────────────────
              RequiredLabel(label: 'Plant (Destination)'),
              AppDropdownSearch<CompanyModel>(
                hint: 'Search plant…',
                menuController: controller.plantController,
                items: controller.plantSearchResults.toList(),
                initialValue: controller.selectedPlant.value,
                searchState: controller.plantSearchState.value,
                labelBuilder: (c) => c.name ?? '',
                onSearchChanged: controller.onPlantQueryChanged,
                onChanged: controller.onPlantSelected,
              ),

              Gap(ScreenUtils.height15),
              Divider(color: bohibaTheme.dividerColor, thickness: 1),
              Gap(ScreenUtils.height10),

              // ── Date range ────────────────────────────────────────────
              RequiredLabel(label: 'Date Range'),
              Gap(4.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From',
                            style: bohibaTheme.textTheme.labelSmall
                                ?.copyWith(fontSize: 11.sp)),
                        Gap(3.h),
                        Obx(() {
                          return DateInputField(
                            controller: controller.fromDate.value,
                            hintText: 'DD-MM-YYYY',
                            onTap: () async {
                              final picked =
                                  await GlobalService.datePickerModal(
                                title: 'Select start date',
                                context: context,
                              );
                              if (picked != null) {
                                controller.fromDate.value.text =
                                    DateFormat('dd-MM-yyyy').format(picked);
                                controller.fromDate.refresh();
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('To',
                            style: bohibaTheme.textTheme.labelSmall
                                ?.copyWith(fontSize: 11.sp)),
                        Gap(3.h),
                        Obx(() {
                          return DateInputField(
                            controller: controller.toDate.value,
                            hintText: 'DD-MM-YYYY',
                            onTap: () async {
                              final picked =
                                  await GlobalService.datePickerModal(
                                title: 'Select end date',
                                context: context,
                              );
                              if (picked != null) {
                                controller.toDate.value.text =
                                    DateFormat('dd-MM-yyyy').format(picked);
                                controller.toDate.refresh();
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),

              Gap(ScreenUtils.height15),

              // ── Active filter count badge ──────────────────────────────
              if (controller.activeFilterCount > 0)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    // color: bohibaTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt_outlined,
                          size: 16.r, color: bohibaTheme.primaryColor),
                      Gap(6.w),
                      Text(
                        '${controller.activeFilterCount} Filter${controller.activeFilterCount > 1 ? 's' : ''} applied',
                        style: bohibaTheme.textTheme.bodySmall?.copyWith(
                          color: bohibaTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              Gap(ScreenUtils.height25),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: PrimaryButton(
              label: 'SEARCH TRIPS',
              onPressed: () {
                Get.toNamed(AppRoute.tripReportList);
                controller.searchTrips();
              },
            ),
          ),
        ),
      );
    });
  }
}
