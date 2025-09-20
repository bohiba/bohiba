import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/pages/widget/status_box_widget.dart';
import 'package:bohiba/pages/widget/vertical_box.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:gap/gap.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:readmore/readmore.dart';

import '/component/bohiba_appbar/trip_appbar.dart';
import '/extensions/bohiba_extension.dart';
import '/model/trip_model.dart';
import '/pages/widget/linear_box_widget.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '/controllers/trip_controller.dart';

class TripPage extends GetView<TripController> {
  const TripPage({super.key});

  @override
  Widget build(BuildContext context) {
    NavigatorState navigatorState = Navigator.of(context);
    return Obx(() {
      return Scaffold(
        appBar: TripAppBar(
          title: controller.tripInfo.value.tripCode ?? '',
        ),
        body: SmartRefresher(
          onRefresh: () async => await controller.refreshTripPage(),
          controller: controller.refreshController,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // From -> To Section
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtils.height10,
                    left: ScreenUtils.height15,
                    right: ScreenUtils.height15,
                    bottom: ScreenUtils.height10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              controller.tripInfo.value.origin ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: bohibaTheme
                                    .textTheme.headlineMedium!.fontSize,
                              ),
                            ),
                            Text(
                              controller.tripInfo.value.startDate ?? '',
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodyMedium!.fontSize,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.titleMedium!.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(RemixIcons.arrow_right_long_line),
                        iconSize: 24.w,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              controller.tripInfo.value.destination ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: bohibaTheme
                                    .textTheme.headlineMedium!.fontSize,
                              ),
                            ),
                            Text(
                              controller.tripInfo.value.endedDate ?? '',
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodyMedium!.fontSize,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.titleMedium!.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Basic Info
                Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtils.height15,
                    right: ScreenUtils.height15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtils.height20),
                        child: Text(
                          'Basic Info',
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                      ),
                      LinearBoxWidget(
                          onClick: () {
                            Get.toNamed(
                              AppRoute.truck,
                              arguments: controller.tripInfo.value.truck!.id,
                            );
                          },
                          header: 'Truck',
                          title: controller.tripInfo.value.truck?.regdNumber ??
                              ''),
                      LinearBoxWidget(
                          header: 'Driver',
                          title: controller.tripInfo.value.driver?.name ?? ''),
                      StatusBoxWidget(
                        header: 'Status',
                        title: controller.tripInfo.value.tripStatus
                                ?.toCapitalizedLabel() ??
                            '',
                        titleColor: controller.statusColor(),
                      ),
                    ],
                  ),
                ),

                // Load Info and Finance Info
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtils.height30,
                    horizontal: ScreenUtils.height15,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: TileDecorative(),
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtils.height10,
                            horizontal: ScreenUtils.width15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Load Info',
                                style: bohibaTheme.textTheme.headlineMedium,
                              ),
                              TripInfoItem(
                                label: 'Material Type',
                                value: controller.tripInfo.value.loadDetail
                                        ?.materialType ??
                                    '',
                              ),
                              TripInfoItem(
                                label: 'Load Weight',
                                value:
                                    '${controller.tripInfo.value.loadDetail?.loadWeight ?? ''} Ton',
                              ),
                              TripInfoItem(
                                label: 'Short Weight',
                                value:
                                    '${controller.tripInfo.value.loadDetail?.shortWeight ?? ''} Ton',
                              ),
                              TripInfoItem(
                                label: 'Rate per Ton',
                                value:
                                    '${controller.tripInfo.value.loadDetail?.rate ?? ''} Ton',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Container(
                          decoration: TileDecorative(),
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtils.height10,
                            horizontal: ScreenUtils.width15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Finance Info',
                                style: bohibaTheme.textTheme.headlineMedium,
                              ),
                              TripInfoItem(
                                label: 'Amount',
                                value:
                                    '₹ ${controller.tripInfo.value.finance?.amount ?? '0.00'}',
                              ),
                              TripInfoItem(
                                label: 'Total Expense',
                                value:
                                    '₹ ${controller.tripInfo.value.finance?.tripExpense ?? ''}',
                              ),
                              TripInfoItem(
                                label: 'Total Payment',
                                value:
                                    '₹ ${controller.tripInfo.value.finance?.tripPayment ?? ''}',
                              ),
                              TripInfoItem(
                                label: 'Total Profit',
                                value:
                                    '₹ ${controller.tripInfo.value.finance?.tripProfit ?? ''}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Trip Payment
                Visibility(
                  visible:
                      controller.tripInfo.value.payments?.isNotEmpty ?? false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          // top: ScreenUtils.height10,
                          left: ScreenUtils.height15,
                          right: ScreenUtils.height15,
                        ),
                        child: Text(
                          'Trip Payment',
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            controller.tripInfo.value.payments?.length ?? 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtils.height15,
                        ),
                        itemBuilder: (context, index) {
                          final TripPayment payment =
                              controller.tripInfo.value.payments![index];
                          return InkWell(
                            onTap: () {
                              navigatorState
                                  .pushNamed(
                                AppRoute.payment,
                                arguments: payment,
                              )
                                  .then(
                                (onValue) async {
                                  if (onValue != null && onValue != false) {
                                    controller.tripInfo.value =
                                        (await controller.getTripInfo(
                                      methodType: MethodType.server,
                                      tripInfo: controller.tripInfo.value,
                                    ))!;
                                  }
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height15,
                              ),
                              width: ScreenUtils.width,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: bohibaTheme.dividerColor,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: bohibaTheme.highlightColor,
                                    // backgroundImage: NetworkImage(GlobalService.getAvatarUrl('')),
                                    child: Icon(EvaIcons.diagonalArrowLeftDown),
                                  ),
                                  Gap(ScreenUtils.height15),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        payment.paidBy ?? 'NA',
                                        maxLines: 1,
                                        style: bohibaTheme.textTheme.bodyMedium,
                                      ),
                                      Text(
                                        payment.paymentTime ?? '',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: bohibaTheme
                                              .textTheme.bodySmall!.fontSize,
                                          fontWeight: bohibaTheme
                                              .textTheme.bodySmall!.fontWeight,
                                          color: bohibaTheme
                                              .textTheme.titleMedium!.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '₹ ${payment.amount}',
                                        style: TextStyle(
                                          color:
                                              bohibaTheme.colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        '${payment.payerType}',
                                        style: TextStyle(
                                          fontSize: bohibaTheme
                                              .textTheme.bodySmall!.fontSize,
                                          fontWeight: bohibaTheme
                                              .textTheme.bodySmall!.fontWeight,
                                          color: bohibaTheme
                                              .textTheme.titleMedium!.color,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Trip Expense
                Visibility(
                  visible:
                      controller.tripInfo.value.expenses?.isNotEmpty ?? false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: ScreenUtils.height30,
                          left: ScreenUtils.height15,
                          right: ScreenUtils.height15,
                        ),
                        child: Text(
                          'Trip Expense',
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: ScreenUtils.height10,
                          left: ScreenUtils.width15,
                          right: ScreenUtils.width15,
                        ),
                        itemCount:
                            controller.tripInfo.value.expenses?.length ?? 0,
                        itemBuilder: (context, index) {
                          final TripExpense expenses =
                              controller.tripInfo.value.expenses![index];
                          return InkWell(
                            onTap: () {
                              navigatorState
                                  .pushNamed(AppRoute.expense,
                                      arguments: expenses)
                                  .then(
                                (onValue) async {
                                  if (onValue != null && onValue != false) {
                                    controller.tripInfo.value =
                                        (await controller.getTripInfo(
                                      methodType: MethodType.server,
                                      tripInfo: controller.tripInfo.value,
                                    ))!;
                                  }
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height15,
                              ),
                              width: ScreenUtils.width,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: bohibaTheme.dividerColor,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: bohibaTheme.highlightColor,
                                    child: Icon(EvaIcons.diagonalArrowLeftDown),
                                  ),
                                  Gap(ScreenUtils.height15),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expenses.expenseType ?? 'NA',
                                        maxLines: 1,
                                        style: bohibaTheme.textTheme.bodyMedium,
                                      ),
                                      Text(
                                        expenses.expenseDate ?? '',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: bohibaTheme
                                              .textTheme.bodySmall!.fontSize,
                                          fontWeight: bohibaTheme
                                              .textTheme.bodySmall!.fontWeight,
                                          color: bohibaTheme
                                              .textTheme.titleMedium!.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '- ₹ ${expenses.paid}',
                                          style: TextStyle(
                                            color:
                                                bohibaTheme.colorScheme.error,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${expenses.paymentMode}',
                                          style: TextStyle(
                                            fontSize: bohibaTheme
                                                .textTheme.bodySmall!.fontSize,
                                            fontWeight: bohibaTheme.textTheme
                                                .bodySmall!.fontWeight,
                                            color: bohibaTheme
                                                .textTheme.titleMedium!.color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Trip Reassignment
                Visibility(
                  visible: controller.tripInfo.value.reassignment?.isNotEmpty ??
                      false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: ScreenUtils.height30,
                          left: ScreenUtils.height15,
                          right: ScreenUtils.height15,
                        ),
                        child: Text(
                          'Reassignment',
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: ScreenUtils.height10,
                          left: ScreenUtils.width15,
                          right: ScreenUtils.width15,
                          bottom: ScreenUtils.height20,
                        ),
                        itemCount:
                            controller.tripInfo.value.reassignment?.length,
                        itemBuilder: (context, index) {
                          final Reassignment reassignment =
                              controller.tripInfo.value.reassignment![index];
                          return InkWell(
                            onTap: () {
                              navigatorState.pushNamed(
                                AppRoute.reassignment,
                                arguments: reassignment,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height15,
                              ),
                              width: ScreenUtils.width,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: bohibaTheme.dividerColor,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: bohibaTheme.highlightColor,
                                    child: Icon(Remix.truck_line),
                                  ),
                                  Gap(ScreenUtils.height15),
                                  SizedBox(
                                    width: ScreenUtils.width * 0.45.w,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reassignment.regdNumber ?? 'NA',
                                          maxLines: 1,
                                          style:
                                              bohibaTheme.textTheme.bodyMedium,
                                        ),
                                        ReadMoreText(
                                          reassignment.reason ?? '',
                                          trimLines: 2,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: ' Read more',
                                          trimExpandedText: ' Show less',
                                          style: TextStyle(
                                            fontSize: bohibaTheme.textTheme
                                                .labelMedium!.fontSize,
                                            color: bohibaTheme
                                                .textTheme.titleMedium!.color,
                                          ),
                                          moreStyle: TextStyle(
                                            fontSize: bohibaTheme.textTheme
                                                .labelMedium!.fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                          lessStyle: TextStyle(
                                            fontSize: bohibaTheme.textTheme
                                                .labelMedium!.fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Text(
                                          reassignment.date ?? 'Not Assigned',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: bohibaTheme
                                                .textTheme.labelSmall!.fontSize,
                                            color: bohibaTheme
                                                .textTheme.titleSmall!.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
