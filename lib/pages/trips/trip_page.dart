import '/dist/app_enums.dart';
import '/dist/component_exports.dart';

import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

import '/controllers/trip_controller.dart';
import '/component/bohiba_appbar/trip_appbar.dart';

import 'trip_page_widget/basic_info_section.dart';
import 'trip_page_widget/trip_expense_section.dart';
import 'trip_page_widget/load_finance_section.dart';
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
            title: controller.tripInfo.value?.tripCode ?? '',
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
                            tripInfo: controller.tripInfo.value,
                            statusLabelColor: controller.statusColor(),
                          ),

                          // Load Info and Finance Info
                          LoadAndFinanceSection(trip: controller.tripInfo.value),

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
                            reassignments: controller.tripInfo.value?.reassignment,
                            onReassignTap: (reassignment) {
                              navigatorState
                                  .pushNamed(
                                AppRoute.reassignment,
                                arguments: reassignment,
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

                          TripDocumentSection(
                            documents: controller.tripInfo.value?.documents,
                            onDocumentTap: (document) {},
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
