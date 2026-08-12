import '/dist/enums/app_enums.dart';
import '/dist/component_exports.dart';

import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

import '/controllers/trip_controller.dart';
import '/component/bohiba_appbar/trip_appbar.dart';

import 'trip_page_widget/basic_info_section.dart';
import 'trip_page_widget/trip_expense_section.dart';
import 'trip_page_widget/trip_document_section.dart';
import 'trip_page_widget/trip_payment_section.dart';
import 'trip_page_widget/trip_reassignement_section.dart';
import 'trip_page_widget/origin_destination_info_section.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class TripPage extends GetView<TripController> {
  const TripPage({super.key});

  @override
  Widget build(BuildContext context) {
    NavigatorState navigatorState = Navigator.of(context);
    return Obx(
      () {
        return Scaffold(
          appBar: TripAppBar(
            title: controller.tripInfo.value?.truck?.regdNumber ?? '',
          ),
          body: SmartRefresher(
            onRefresh: () async => await controller.refreshTripPage(),
            controller: controller.refreshController,
            child: (controller.tripInfo.value == null)
                ? Container(
                    height: ScreenUtils.height,
                    width: ScreenUtils.width,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          controller.strErrorTitle.value,
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                        Text(
                          controller.strErrorDesc.value,
                          textAlign: TextAlign.center,
                          style: bohibaTheme.textTheme.titleMedium,
                        )
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // From -> To Section
                          OriginDestinationInfoSection(
                            tripInfo: controller.tripInfo.value,
                          ),

                          // Basic Info
                          BasicInfoSection(
                            controller: controller,
                          ),

                          // MATERIAL | REVENUE | PAYMENT
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 8.h),
                            child: Row(
                              children: controller.tripCardClassifications
                                  .map(
                                    (c) => Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w),
                                        child: TripCard(classification: c),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),

                          // Trip Payment
                          TripPaymentSection(
                            payments: controller.tripInfo.value?.payments,
                            onPaymentTap: (payment) {
                              navigatorState
                                  .pushNamed(
                                AppRoute.payment,
                                arguments: payment,
                              )
                                  .then(
                                (onValue) async {
                                  if (onValue != null && onValue != false) {
                                    await controller.getTripInfo(
                                      methodType: MethodType.api,
                                      id: controller.tripInfo.value!.id!,
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          // Trip Expense
                          TripExpenseSection(
                            expenses: controller.tripInfo.value?.expenses,
                            onExpenseTap: (expenses) {
                              navigatorState
                                  .pushNamed(
                                AppRoute.expense,
                                arguments: expenses,
                              )
                                  .then(
                                (onValue) async {
                                  if (onValue != null && (onValue != false)) {
                                    await controller.getTripInfo(
                                      methodType: MethodType.api,
                                      id: controller.tripInfo.value!.id!,
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          // Trip Reassignment
                          TripReassignmentSection(
                            controller: controller,
                          ),

                          TripDocumentSection(
                            controller: controller,
                          ),
                          Gap(ScreenUtils.height65)
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class TripCard extends StatelessWidget {
  final TripCardClassification classification;
  const TripCard({super.key, required this.classification});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: classification.color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: classification.color.withValues(alpha: 0.30), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(classification.icon,
                  color: classification.color, size: 18.r),
              Visibility(
                visible: classification.indicatorIcon != null,
                child: Icon(classification.indicatorIcon,
                    color: classification.color, size: 18.r),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classification.header,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: bohibaTheme.textTheme.headlineMedium,
              ),
              Text(
                classification.subHeader,
                style: bohibaTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 9.sp,
                  color: bohibaTheme.textTheme.titleMedium!.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
