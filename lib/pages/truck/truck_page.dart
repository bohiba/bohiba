import 'package:bohiba/services/launcher_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/component/bohiba_buttons/primary_button.dart';

import '/component/bohiba_appbar/truck_appbar.dart';
import '/controllers/truck_controller.dart';
import '/routes/app_route.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/pages/widget/role_widget.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';
import 'package:gap/gap.dart';
import '/dist/component_exports.dart';
import 'package:flutter/material.dart';

class TruckPage extends GetView<TruckController> {
  const TruckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Obx(() {
      return Scaffold(
        appBar: TruckAppbar(truck: controller.truckModel.value),
        body: SafeArea(
          child: SmartRefresher(
            onRefresh: () async => await controller.onRefreshTruckPage(),
            controller: controller.refreshTruckPage,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: ScreenUtils.width,
                    height: ScreenUtils.width * 0.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: bohibaTheme.canvasColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtils.height10,
                      left: ScreenUtils.width15,
                      right: ScreenUtils.width15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoleWidget(
                          driverWidget: Text(
                            "Owner Info",
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                          truckOwnerWidget: Text(
                            "Driver Info",
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),
                        Gap(ScreenUtils.width5),
                        RoleWidget(
                          truckOwnerWidget: controller.isDriverAssigned.isFalse
                              ? Center(
                                  child: PrimaryButton(
                                    height: 35,
                                    width: ScreenUtils.width,
                                    label: 'Assign Driver',
                                    onPressed: () {
                                      navigateState
                                          .pushNamed(AppRoute.editTruck,
                                              arguments:
                                                  controller.truckModel.value)
                                          .then(
                                        (onValue) async {
                                          await controller.getTruckInfo(
                                            id: controller.truckModel.value.id!
                                                .toString(),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                )
                              : Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: bohibaTheme.dividerColor,
                                    ),
                                    Gap(ScreenUtils.height15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BohibaMarqueeText(
                                          width: ScreenUtils.width * 0.35,
                                          text: controller.truckModel.value
                                                  .driver?.name ??
                                              '',
                                          overflowText: controller.truckModel
                                                  .value.driver?.name ??
                                              '',
                                        ),
                                        Text(
                                          controller.truckModel.value.driver
                                                  ?.uuid ??
                                              'NA',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: bohibaTheme.textTheme
                                                .titleMedium!.fontSize,
                                            fontWeight: bohibaTheme.textTheme
                                                .bodySmall!.fontWeight,
                                            color: bohibaTheme
                                                .textTheme.titleMedium!.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Visibility(
                                      visible: controller.truckModel.value
                                                  .driver?.mobileNumber !=
                                              null ||
                                          controller.truckModel.value.driver
                                                  ?.mobileNumber !=
                                              '',
                                      child: GestureDetector(
                                        onTap: () async =>
                                            await LauncherService.makePhoneCall(
                                          controller.truckModel.value.driver!
                                              .mobileNumber!,
                                        ),
                                        child: Container(
                                          height: ScreenUtils.height30.w,
                                          width: ScreenUtils.height30.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: bohibaTheme
                                                .colorScheme.onSurface
                                                .withValues(alpha: 0.15),
                                          ),
                                          child: Icon(
                                            Icons.phone_sharp,
                                            size: 16.w,
                                            color: bohibaTheme
                                                .colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          driverWidget: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: bohibaTheme.dividerColor,
                              ),
                              Gap(ScreenUtils.height15),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BohibaMarqueeText(
                                    width: ScreenUtils.width * 0.35,
                                    text:
                                        controller.truckModel.value.owner?.name,
                                    overflowText: controller
                                        .truckModel.value.driver?.name,
                                  ),
                                  Text(
                                    controller.truckModel.value.owner?.uuid ??
                                        '',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: bohibaTheme
                                          .textTheme.titleMedium!.fontSize,
                                      fontWeight: bohibaTheme
                                          .textTheme.bodySmall!.fontWeight,
                                      color: bohibaTheme
                                          .textTheme.titleMedium!.color,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Visibility(
                                visible: controller.truckModel.value.owner
                                            ?.mobileNumber !=
                                        null ||
                                    controller.truckModel.value.owner
                                            ?.mobileNumber !=
                                        '',
                                child: GestureDetector(
                                  onTap: () async =>
                                      LauncherService.makePhoneCall(
                                    controller
                                        .truckModel.value.owner!.mobileNumber!,
                                  ),
                                  child: Container(
                                    height: 36.w,
                                    width: 36.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: bohibaTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.25),
                                    ),
                                    child: Icon(
                                      Icons.phone_sharp,
                                      size: 16.w,
                                      color: bohibaTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtils.height20,
                            bottom: ScreenUtils.height5,
                          ),
                          child: Text(
                            'Important Date',
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),
                        LinearBoxWidget(
                          header: 'Regd. Date',
                          title: controller.truckModel.value.registration
                                  ?.registrationDate ??
                              'NA',
                        ),
                        LinearBoxWidget(
                          header: 'Insurance Upto',
                          title: controller
                                  .truckModel.value.validity?.insuranceUpto ??
                              'NA',
                        ),
                        LinearBoxWidget(
                          header: 'Tax Upto',
                          title:
                              controller.truckModel.value.validity?.taxUpto ??
                                  'NA',
                        ),
                        LinearBoxWidget(
                          header: 'Pucc Upto',
                          title:
                              controller.truckModel.value.validity?.puccUpto ??
                                  'NA',
                        ),
                        LinearBoxWidget(
                          header: 'Last synced',
                          title: controller.truckModel.value.updatedAt ?? 'NA',
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtils.height20,
                            bottom: ScreenUtils.height5,
                          ),
                          child: Text(
                            'Vehicle Details',
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),
                        LinearBoxWidget(
                          header: 'Fuel',
                          title: controller.truckModel.value.specs?.fuelType,
                        ),
                        LinearBoxWidget(
                          header: 'Unladen',
                          title: controller
                                  .truckModel.value.specs?.unladenWeight
                                  .toString() ??
                              'NA',
                        ),
                        LinearBoxWidget(
                          header: 'Model Number',
                          title: controller.truckModel.value.specs?.model,
                        ),
                        RoleWidget(
                          truckOwnerWidget: LinearBoxWidget(
                            header: 'Engine Number',
                            title:
                                controller.truckModel.value.specs?.engineNo ??
                                    'NA',
                          ),
                        ),
                        RoleWidget(
                          truckOwnerWidget: LinearBoxWidget(
                            header: 'Chassis',
                            title:
                                controller.truckModel.value.specs?.chassisNo ??
                                    'NA',
                          ),
                        ),
                        RoleWidget(
                          truckOwnerWidget: LinearBoxWidget(
                            header: 'Financer',
                            title:
                                controller.truckModel.value.specs?.financer ??
                                    'NA',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtils.height20,
                            bottom: ScreenUtils.height5,
                          ),
                          child: Text(
                            'Insurance Details',
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),
                        LinearBoxWidget(
                          header: 'Insurance Company',
                          title: controller
                                  .truckModel.value.specs?.insuranceCompany ??
                              'NA',
                        ),
                        LinearBoxWidget(
                          header: 'Insurance no',
                          title: controller
                                  .truckModel.value.specs?.insurancePolicyNo ??
                              'NA',
                        ),
                        LinearBoxWidget(
                          header: 'Valid Upto',
                          title: controller
                                  .truckModel.value.validity?.insuranceUpto ??
                              'NA',
                        ),
                        /*Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtils.height20,
                            bottom: ScreenUtils.height5,
                          ),
                          child: Text(
                            'Other Details',
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),*/
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
