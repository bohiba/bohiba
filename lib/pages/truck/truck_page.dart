import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_appbar/truck_appbar.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/dist/component_exports.dart';
import '/services/launcher_service.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/linear_box_widget.dart';
import '/controllers/truck_controller.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
                                          if (onValue != null) {
                                            await controller.getTruckInfo(
                                              id: controller
                                                  .truckModel.value.id!,
                                            );
                                          }
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
                                                  .driverName ??
                                              '',
                                          overflowText: controller.truckModel
                                                  .value.driverName ??
                                              '',
                                        ),
                                        Text(
                                          controller.truckModel.value
                                                  .driverUuid ??
                                              '',
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
                                                  .driverMobileNumber !=
                                              null ||
                                          controller.truckModel.value
                                                  .driverMobileNumber !=
                                              '',
                                      child: GestureDetector(
                                        onTap: () async =>
                                            await LauncherService.makePhoneCall(
                                          controller.truckModel.value
                                              .driverMobileNumber!,
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
                                    text: controller.truckModel.value.ownerName,
                                    overflowText:
                                        controller.truckModel.value.ownerName,
                                  ),
                                  Text(
                                    controller.truckModel.value.ownerUuid ?? '',
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
                                visible: controller.truckModel.value
                                            .ownerMobileNumber !=
                                        null ||
                                    controller.truckModel.value
                                            .ownerMobileNumber !=
                                        '',
                                child: GestureDetector(
                                  onTap: () async =>
                                      LauncherService.makePhoneCall(
                                    controller
                                        .truckModel.value.ownerMobileNumber!,
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
                          title: controller.truckModel.value.regdDate,
                        ),
                        LinearBoxWidget(
                          header: 'Insurance Upto',
                          title: controller.truckModel.value.insuranceUpto,
                        ),
                        LinearBoxWidget(
                          header: 'Tax Upto',
                          title: controller.truckModel.value.taxUpto,
                        ),
                        LinearBoxWidget(
                          header: 'Pucc Upto',
                          title: controller.truckModel.value.puccUpto,
                        ),
                        LinearBoxWidget(
                          header: 'Last synced',
                          title: controller.truckModel.value.updatedAt,
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
                          title: controller.truckModel.value.vhFuelType,
                        ),
                        LinearBoxWidget(
                          header: 'Unladen',
                          title:
                              "${controller.truckModel.value.vhUnladenWeight ?? ''}",
                        ),
                        LinearBoxWidget(
                          header: 'Model Number',
                          title: controller.truckModel.value.vhModel,
                        ),
                        RoleWidget(
                          truckOwnerWidget: LinearBoxWidget(
                            header: 'Engine Number',
                            title: controller.truckModel.value.vhEngineNo,
                          ),
                        ),
                        RoleWidget(
                          truckOwnerWidget: LinearBoxWidget(
                            header: 'Chassis',
                            title: controller.truckModel.value.vhChassisNo,
                          ),
                        ),
                        RoleWidget(
                          truckOwnerWidget: LinearBoxWidget(
                            header: 'Financer',
                            title: controller.truckModel.value.vhFinancer,
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
                          title: controller.truckModel.value.vhInsuranceCompany,
                        ),
                        LinearBoxWidget(
                          header: 'Insurance no',
                          title: controller.truckModel.value.vhInsuranceNo,
                        ),
                        LinearBoxWidget(
                          header: 'Valid Upto',
                          title: controller.truckModel.value.insuranceUpto,
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
