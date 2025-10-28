import 'package:bohiba/extensions/bohiba_extension.dart';

import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/pages/widget/status_box_widget.dart';
import '/pages/widget/vertical_box.dart';
import '/routes/app_route.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/linear_box_widget.dart';
import '/component/bohiba_appbar/trip_appbar.dart';

import '/controllers/trip_controller.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:remixicon/remixicon.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From -> To Section
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtils.height15,
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
                                  fontSize: bohibaTheme
                                      .textTheme.bodyMedium!.fontSize,
                                  fontWeight: bohibaTheme
                                      .textTheme.bodySmall!.fontWeight,
                                  color:
                                      bohibaTheme.textTheme.titleMedium!.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          RemixIcons.arrow_right_double_line,
                          color: bohibaTheme.primaryColor,
                          size: 32.w,
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
                                  fontSize: bohibaTheme
                                      .textTheme.bodyMedium!.fontSize,
                                  fontWeight: bohibaTheme
                                      .textTheme.bodySmall!.fontWeight,
                                  color:
                                      bohibaTheme.textTheme.titleMedium!.color,
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
                          title: controller.tripInfo.value.truck?.regdNumber,
                        ),
                        RoleWidget(
                          truckOwnerWidget: LinearBoxWidget(
                            header: 'Driver',
                            title: controller.tripInfo.value.driver?.name,
                          ),
                          driverWidget: LinearBoxWidget(
                            header: 'Owner',
                            title: controller.tripInfo.value.owner?.name,
                          ),
                        ),
                        StatusBoxWidget(
                          header: 'Status',
                          title: controller
                                  .tripInfo.value.tripStatus?.capitalizeFirst
                                  ?.replaceAll('_', ' ') ??
                              '',
                          statusColor: controller.statusColor(),
                        ),
                      ],
                    ),
                  ),

                  // Load Info and Finance Info
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtils.height30,
                      left: ScreenUtils.height15,
                      right: ScreenUtils.height15,
                      bottom: ScreenUtils.height10,
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
                            margin: EdgeInsets.only(right: ScreenUtils.width10),
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
                                      '${controller.tripInfo.value.loadDetail?.loadWeight ?? '0.0'} Ton',
                                ),
                                TripInfoItem(
                                  label: 'Short Weight',
                                  value:
                                      '${controller.tripInfo.value.loadDetail?.shortWeight ?? '0.0'} Ton',
                                ),
                                TripInfoItem(
                                  label: 'Rate per Ton',
                                  value:
                                      '${controller.tripInfo.value.loadDetail?.rate ?? '0.0'} Ton',
                                ),
                              ],
                            ),
                          ),
                        ),
                        RoleWidget(
                          truckOwnerWidget: Expanded(
                            child: Container(
                              decoration: TileDecorative(),
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height10,
                                horizontal: ScreenUtils.width15,
                              ),
                              margin:
                                  EdgeInsets.only(left: ScreenUtils.width10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      await controller.getTripInfo(
                                        methodType: MethodType.api,
                                        id: controller.tripInfo.value.id!,
                                      );
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
                                      backgroundColor:
                                          bohibaTheme.highlightColor,
                                      child:
                                          Icon(EvaIcons.diagonalArrowLeftDown),
                                    ),
                                    Gap(ScreenUtils.height15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          payment.paidBy ?? '',
                                          maxLines: 1,
                                          style:
                                              bohibaTheme.textTheme.bodyMedium,
                                        ),
                                        Text(
                                          payment.paymentTime ?? '',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: bohibaTheme
                                                .textTheme.bodySmall!.fontSize,
                                            fontWeight: bohibaTheme.textTheme
                                                .bodySmall!.fontWeight,
                                            color: bohibaTheme
                                                .textTheme.titleMedium!.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          payment.amount == null
                                              ? ''
                                              : '₹ ${payment.amount ?? ''}',
                                          style: TextStyle(
                                            color: bohibaTheme
                                                .colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          payment.payerType ?? '',
                                          style: TextStyle(
                                            fontSize: bohibaTheme
                                                .textTheme.bodySmall!.fontSize,
                                            fontWeight: bohibaTheme.textTheme
                                                .bodySmall!.fontWeight,
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
                            'Expense',
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: ScreenUtils.width15,
                            right: ScreenUtils.width15,
                          ),
                          separatorBuilder: (context, index) {
                            return Divider(thickness: 2.0);
                          },
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
                                      await controller.getTripInfo(
                                        methodType: MethodType.api,
                                        id: controller.tripInfo.value.id!,
                                      );
                                    }
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtils.height15,
                                ),
                                width: ScreenUtils.width,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          bohibaTheme.highlightColor,
                                      child:
                                          Icon(EvaIcons.diagonalArrowLeftDown),
                                    ),
                                    Gap(ScreenUtils.height15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expenses.expenseType
                                                  ?.toCapitalizedLabel() ??
                                              '',
                                          maxLines: 1,
                                          style:
                                              bohibaTheme.textTheme.bodyMedium,
                                        ),
                                        Text(
                                          expenses.expenseDate ?? '',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: bohibaTheme
                                                .textTheme.bodySmall!.fontSize,
                                            fontWeight: bohibaTheme.textTheme
                                                .bodySmall!.fontWeight,
                                            color: bohibaTheme
                                                .textTheme.titleMedium!.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              fontSize: bohibaTheme.textTheme
                                                  .bodySmall!.fontSize,
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
                    visible:
                        controller.tripInfo.value.reassignment?.isNotEmpty ??
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
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: ScreenUtils.width15,
                            right: ScreenUtils.width15,
                          ),
                          itemCount:
                              controller.tripInfo.value.reassignment?.length ??
                                  0,
                          separatorBuilder: (context, index) {
                            return Divider(
                              thickness: 2.0,
                            );
                          },
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
                                  vertical: ScreenUtils.height10,
                                ),
                                width: ScreenUtils.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          bohibaTheme.highlightColor,
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
                                            reassignment.regdNumber ?? '',
                                            maxLines: 1,
                                            style: bohibaTheme
                                                .textTheme.bodyMedium,
                                          ),
                                          ReadMoreText(
                                            reassignment
                                                    .reason?.capitalizeFirst ??
                                                '',
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
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.arrow_forward_ios_rounded)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: controller.tripInfo.value.documents?.isNotEmpty ??
                        false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtils.height20,
                            left: ScreenUtils.height15,
                            right: ScreenUtils.height15,
                          ),
                          child: Text(
                            'Trip Document',
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            top: ScreenUtils.height10,
                            left: ScreenUtils.width15,
                            right: ScreenUtils.width15,
                            bottom: ScreenUtils.height20,
                          ),
                          itemCount:
                              controller.tripInfo.value.documents?.length,
                          itemBuilder: (context, index) {
                            TripDocument document =
                                controller.tripInfo.value.documents![index];
                            return InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: bohibaTheme.canvasColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: ScreenUtils.height * 0.185,
                                      decoration: BoxDecoration(
                                        color: bohibaTheme.cardColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.r),
                                          topRight: Radius.circular(8.r),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtils.width10,
                                        vertical: ScreenUtils.width5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BohibaMarqueeText(
                                            width: ScreenUtils.width,
                                            text: document.docType ?? '',
                                            overflowText:
                                                document.docType ?? '',
                                            style: bohibaTheme
                                                .textTheme.titleMedium,
                                            marqueeTextStyle: bohibaTheme
                                                .textTheme.titleMedium,
                                          ),
                                          BohibaMarqueeText(
                                            width: ScreenUtils.width,
                                            text: document.updatedAt ?? '',
                                            overflowText:
                                                document.updatedAt ?? '',
                                            style: bohibaTheme
                                                .textTheme.titleMedium,
                                            marqueeTextStyle: bohibaTheme
                                                .textTheme.titleMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: ScreenUtils.height10,
                            crossAxisSpacing: ScreenUtils.width10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
