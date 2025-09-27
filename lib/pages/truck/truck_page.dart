import '/pages/widget/role_widget.dart';

import '/component/bohiba_appbar/truck_appbar.dart';
import '/controllers/truck_controller.dart';
import '/routes/app_route.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/pages/widget/detail_box_widget.dart';
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              RoleWidget(
                                truckOwnerWidget: DetailsBox(
                                  headline: 'Driver',
                                  title:
                                      controller.truckModel.value.owner?.name ??
                                          'Assign Driver',
                                  titleColor: bohibaTheme.primaryColor,
                                  onClick: controller
                                              .truckModel.value.driver?.name !=
                                          null
                                      ? null
                                      : () {
                                          navigateState
                                              .pushNamed(AppRoute.editTruck,
                                                  arguments: controller
                                                      .truckModel.value)
                                              .then(
                                            (onValue) async {
                                              if (onValue != null) {
                                                await controller.getTruckInfo(
                                                  id: controller
                                                      .truckModel.value.id!
                                                      .toString(),
                                                );
                                              }
                                            },
                                          );
                                        },
                                ),
                                driverWidget: DetailsBox(
                                  headline: 'Owner',
                                  title:
                                      controller.truckModel.value.owner?.name ??
                                          '',
                                  titleColor: bohibaTheme.primaryColor,
                                ),
                              ),
                              RoleWidget(
                                truckOwnerWidget: DetailsBox(
                                  headline: 'Mobile no',
                                  title: controller.truckModel.value.driver
                                          ?.mobileNumber ??
                                      '',
                                  titleColor: bohibaTheme
                                      .listTileTheme.titleTextStyle!.color,
                                ),
                                driverWidget: DetailsBox(
                                  headline: 'Mobile no',
                                  title: controller.truckModel.value.owner
                                          ?.mobileNumber ??
                                      '',
                                  titleColor: bohibaTheme
                                      .listTileTheme.titleTextStyle!.color,
                                ),
                              ),
                              RoleWidget(
                                truckOwnerWidget: DetailsBox(
                                  headline: 'UUID',
                                  title: controller
                                          .truckModel.value.driver?.uuid ??
                                      '',
                                  titleColor: bohibaTheme
                                      .listTileTheme.titleTextStyle!.color,
                                ),
                                driverWidget: DetailsBox(
                                  headline: 'UUID',
                                  title:
                                      controller.truckModel.value.owner?.uuid ??
                                          '',
                                  titleColor: bohibaTheme
                                      .listTileTheme.titleTextStyle!.color,
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
