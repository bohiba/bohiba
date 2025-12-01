import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/extensions/bohiba_extension.dart';

import '/routes/app_route.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';

import '/component/image_path.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/vertical_box.dart';
import '/pages/widget/status_box_widget.dart';
import '/pages/widget/linear_box_widget.dart';
import '/controllers/trip_controller.dart';
import '/component/bohiba_appbar/trip_appbar.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:remixicon/remixicon.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                          Padding(
                            padding: EdgeInsets.only(
                              top: ScreenUtils.height15,
                              bottom: ScreenUtils.height10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      BohibaMarqueeText(
                                        width: ScreenUtils.width * 0.32,
                                        alwaysScroll: true,
                                        text: controller.tripInfo.value?.origin?.toUpperCase() ?? '',
                                        style: bohibaTheme.textTheme.headlineMedium,
                                        alignment: Alignment.center,
                                        alignText: TextAlign.center,
                                        overflowText: controller.tripInfo.value?.origin?.toUpperCase() ?? '',
                                        marqueeTextStyle: bohibaTheme.textTheme.headlineMedium,
                                        preserFontSize: [
                                          bohibaTheme.textTheme.headlineMedium!.fontSize!,
                                        ],
                                        minFontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                                      ),
                                      Text(
                                        controller.tripInfo.value?.startDate ?? '',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                                          fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                          color: bohibaTheme.textTheme.titleMedium!.color,
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
                                      BohibaMarqueeText(
                                        width: ScreenUtils.width * 0.32,
                                        alwaysScroll: true,
                                        text: controller.tripInfo.value?.destination?.toUpperCase() ?? '',
                                        alignment: Alignment.center,
                                        alignText: TextAlign.center,
                                        style: bohibaTheme.textTheme.headlineMedium,
                                        overflowText: controller.tripInfo.value?.destination?.toUpperCase() ?? '',
                                        marqueeTextStyle: bohibaTheme.textTheme.headlineMedium,
                                        preserFontSize: [
                                          bohibaTheme.textTheme.headlineMedium!.fontSize!,
                                        ],
                                        minFontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                                      ),
                                      Text(
                                        controller.tripInfo.value?.endedDate ?? '',
                                        style: TextStyle(
                                          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                                          fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
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
                                  onClick: () {},
                                  header: 'Transporter',
                                  title: controller.tripInfo.value?.transporter?.toDisplayLabel(),
                                ),
                                LinearBoxWidget(
                                  onClick: () {
                                    Get.toNamed(
                                      AppRoute.truck,
                                      arguments: controller.tripInfo.value?.truck!.regdNumber,
                                    );
                                  },
                                  header: 'Truck',
                                  title: controller.tripInfo.value?.truck?.regdNumber,
                                ),
                                RoleWidget(
                                  truckOwnerWidget: LinearBoxWidget(
                                    header: 'Driver',
                                    title: controller.tripInfo.value?.driver?.name ?? 'No driver',
                                  ),
                                  driverWidget: LinearBoxWidget(
                                    header: 'Owner',
                                    title: controller.tripInfo.value?.owner?.name,
                                  ),
                                ),
                                StatusBoxWidget(
                                  header: 'Status',
                                  title: controller.tripInfo.value?.tripStatus ?? '',
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
                                    decoration: TileDecorative(
                                      color: bohibaTheme.cardColor.withValues(alpha: 0.5),
                                    ),
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
                                          value: controller.tripInfo.value?.loadDetail?.materialType?.toCapitalizedLabel() ?? '',
                                        ),
                                        TripInfoItem(
                                          label: 'Load Weight',
                                          value: '${controller.tripInfo.value?.loadDetail?.loadWeight ?? '0.0'} Ton',
                                        ),
                                        TripInfoItem(
                                          label: 'Short Weight',
                                          value: '${controller.tripInfo.value?.loadDetail?.shortWeight ?? '0.0'} Ton',
                                        ),
                                        TripInfoItem(
                                          label: 'Rate per Ton',
                                          value: '${controller.tripInfo.value?.loadDetail?.rate ?? '0.0'} Ton',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                RoleWidget(
                                  truckOwnerWidget: Expanded(
                                    child: Container(
                                      decoration: TileDecorative(
                                        color: bohibaTheme.cardColor.withValues(alpha: 0.5),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: ScreenUtils.height10,
                                        horizontal: ScreenUtils.width15,
                                      ),
                                      margin: EdgeInsets.only(left: ScreenUtils.width10),
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
                                            value: '₹ ${controller.tripInfo.value?.finance?.amount ?? '0.00'}',
                                          ),
                                          TripInfoItem(
                                            label: 'Total Expense',
                                            value: '₹ ${controller.tripInfo.value?.finance?.tripExpense ?? ''}',
                                          ),
                                          TripInfoItem(
                                            label: 'Total Payment',
                                            value: '₹ ${controller.tripInfo.value?.finance?.tripPayment ?? ''}',
                                          ),
                                          TripInfoItem(
                                            label: 'Total Profit',
                                            value: '₹ ${controller.tripInfo.value?.finance?.tripProfit ?? ''}',
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
                            visible: controller.tripInfo.value?.payments?.isNotEmpty ?? false,
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
                                    'Payments',
                                    style: bohibaTheme.textTheme.headlineMedium,
                                  ),
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller.tripInfo.value?.payments?.length ?? 0,
                                  padding: EdgeInsets.only(
                                    left: ScreenUtils.height15,
                                    right: ScreenUtils.height15,
                                  ),
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  itemBuilder: (context, index) {
                                    final TripPayment payment = controller.tripInfo.value!.payments![index];
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
                                                id: controller.tripInfo.value!.id!,
                                              );
                                            }
                                          },
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
                                              backgroundColor: bohibaTheme.colorScheme.onSurface,
                                              child: Icon(EvaIcons.diagonalArrowRightUpOutline),
                                            ),
                                            Gap(ScreenUtils.height15),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  payment.paidBy?.toCapitalizedLabel() ?? '',
                                                  maxLines: 1,
                                                  style: bohibaTheme.textTheme.bodyMedium,
                                                ),
                                                Text(
                                                  payment.paymentTime?.toCapitalizedLabel() ?? '',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                                                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                                    color: bohibaTheme.textTheme.titleMedium!.color,
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
                                                  payment.amount == null ? '' : '₹ ${payment.amount ?? ''}',
                                                  style: TextStyle(
                                                    color: bohibaTheme.colorScheme.onPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  payment.payerType?.toCapitalizedLabel() ?? '',
                                                  style: TextStyle(
                                                    fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                                                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                                    color: bohibaTheme.textTheme.titleMedium!.color,
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
                            visible: (controller.tripInfo.value != null && controller.tripInfo.value?.expenses?.isNotEmpty == true),
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
                                    'Expenses',
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
                                    return Divider();
                                  },
                                  itemCount: controller.tripInfo.value?.expenses?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final TripExpense expenses = controller.tripInfo.value!.expenses![index];
                                    return InkWell(
                                      onTap: () {
                                        navigatorState.pushNamed(AppRoute.expense, arguments: expenses).then(
                                          (onValue) async {
                                            if (onValue != null && (onValue != false)) {
                                              await controller.getTripInfo(
                                                id: controller.tripInfo.value!.id!,
                                              );
                                            }
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: ScreenUtils.height10,
                                        ),
                                        width: ScreenUtils.width,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: bohibaTheme.colorScheme.onSurface,
                                              child: Icon(EvaIcons.diagonalArrowLeftDown),
                                            ),
                                            Gap(ScreenUtils.height15),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  expenses.expenseType?.toCapitalizedLabel() ?? '',
                                                  maxLines: 1,
                                                  style: bohibaTheme.textTheme.bodyMedium,
                                                ),
                                                Text(
                                                  expenses.expenseDate ?? '',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                                                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                                    color: bohibaTheme.textTheme.titleMedium!.color,
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
                                                      color: bohibaTheme.colorScheme.error,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    '${expenses.paymentMode}',
                                                    style: TextStyle(
                                                      fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                                                      fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                                      color: bohibaTheme.textTheme.titleMedium!.color,
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
                            visible: (controller.tripInfo.value != null && controller.tripInfo.value?.reassignment?.isNotEmpty == true),
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
                                  itemCount: controller.tripInfo.value?.reassignment?.length ?? 0,
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  itemBuilder: (context, index) {
                                    final Reassignment reassignment = controller.tripInfo.value!.reassignment![index];
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
                                              backgroundColor: bohibaTheme.colorScheme.onSurface,
                                              child: Icon(Remix.truck_line),
                                            ),
                                            Gap(ScreenUtils.height15),
                                            SizedBox(
                                              width: ScreenUtils.width * 0.45.w,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    reassignment.regdNumber ?? '',
                                                    maxLines: 1,
                                                    style: bohibaTheme.textTheme.bodyMedium,
                                                  ),
                                                  ReadMoreText(
                                                    reassignment.reason?.toCapitalizedLabel() ?? '',
                                                    trimLines: 2,
                                                    trimMode: TrimMode.Line,
                                                    trimCollapsedText: ' Read more',
                                                    trimExpandedText: ' Show less',
                                                    style: TextStyle(
                                                      fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                                                      fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                                      color: bohibaTheme.textTheme.titleMedium!.color,
                                                    ),
                                                    moreStyle: TextStyle(
                                                      fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                    lessStyle: TextStyle(
                                                      fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
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
                            visible: (controller.tripInfo.value != null && controller.tripInfo.value?.documents?.isNotEmpty == true),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: ScreenUtils.height25,
                                    left: ScreenUtils.height15,
                                    right: ScreenUtils.height15,
                                  ),
                                  child: Text(
                                    'Documents',
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
                                  itemCount: controller.tripInfo.value?.documents?.length,
                                  itemBuilder: (context, index) {
                                    TripDocument document = controller.tripInfo.value!.documents![index];
                                    return InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: bohibaTheme.cardColor,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: ScreenUtils.height * 0.185,
                                              decoration: BoxDecoration(
                                                color: bohibaTheme.dividerColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.r),
                                                  topRight: Radius.circular(8.r),
                                                ),
                                              ),
                                              child: document.image == null
                                                  ? null
                                                  : ClipRRect(
                                                      borderRadius: BorderRadiusGeometry.only(
                                                        topLeft: Radius.circular(8.r),
                                                        topRight: Radius.circular(8.r),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: '${ImagePath.tripImage}/${document.image}',
                                                        height: ScreenUtils.height * 0.185,
                                                        width: ScreenUtils.width,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => Container(
                                                          color: Colors.grey.shade200,
                                                        ),
                                                        errorWidget: (context, url, error) => Container(
                                                          color: bohibaTheme.dividerColor,
                                                          child: const Icon(Icons.broken_image, size: 20),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtils.width10,
                                                vertical: ScreenUtils.width10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  BohibaMarqueeText(
                                                    width: ScreenUtils.width,
                                                    text: document.docType?.toCapitalizedLabel() ?? '',
                                                    overflowText: document.docType?.toCapitalizedLabel() ?? '',
                                                    style: bohibaTheme.textTheme.bodySmall,
                                                    marqueeTextStyle: bohibaTheme.textTheme.bodySmall,
                                                    preserFontSize: [
                                                      bohibaTheme.textTheme.bodySmall!.fontSize!,
                                                    ],
                                                  ),
                                                  BohibaMarqueeText(
                                                    width: ScreenUtils.width,
                                                    text: document.updatedAt ?? '',
                                                    overflowText: document.updatedAt ?? '',
                                                    style: bohibaTheme.textTheme.titleMedium,
                                                    marqueeTextStyle: bohibaTheme.textTheme.titleMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.82,
                                    mainAxisSpacing: ScreenUtils.height10,
                                    crossAxisSpacing: ScreenUtils.width10,
                                  ),
                                ),
                              ],
                            ),
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
