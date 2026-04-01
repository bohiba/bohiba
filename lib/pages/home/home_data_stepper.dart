import 'package:gap/gap.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/pages/widget/role_widget.dart';
import '/routes/app_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/controllers/home_controller.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDataStepper extends GetView<HomeController> {
  const HomeDataStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return RoleWidget(
      truckOwnerWidget: Obx(() {
        if (controller.arrDriver.value == null && controller.arrTruck.value == null && controller.arrMines.value == null) {
          return SizedBox.shrink();
        } else if ((controller.arrDriver.value?.isNotEmpty ?? true) && (controller.arrTruck.value?.isNotEmpty ?? true) && (controller.arrTrip.value?.isNotEmpty ?? true)) {
          return SizedBox.shrink();
        } else {
          if (controller.arrDriver.value?.isEmpty ?? true) {
            controller.currentStep.value = 0;
          } else if (controller.arrTruck.value?.isEmpty ?? true) {
            controller.currentStep.value = 1;
          } else {
            controller.currentStep.value = 2;
          }
          return Padding(
            padding: EdgeInsets.only(bottom: ScreenUtils.height20),
            child: SizedBox(
              height: ScreenUtils.height * 0.25,
              child: Stepper(
                elevation: 0,
                physics: NeverScrollableScrollPhysics(),
                type: StepperType.horizontal,
                currentStep: controller.currentStep.value,
                controlsBuilder: (context, details) => SizedBox.shrink(),
                onStepCancel: () {
                  if (controller.currentStep > 0) controller.currentStep -= 1;
                },
                onStepTapped: (stepIndex) {
                  if (controller.isStepEnabled(stepIndex)) {
                    controller.currentStep.value = stepIndex;
                  }
                },
                steps: [
                  Step(
                    title: const Text("Driver"),
                    content: Center(
                      child: Column(
                        children: [
                          Text(
                            "Add driver information to assign them to trips.",
                            textAlign: TextAlign.center,
                            style: bohibaTheme.textTheme.titleLarge,
                          ),
                          PrimaryButton(
                            height: 25.h,
                            width: ScreenUtils.width * 0.3,
                            onPressed: () {
                              navigatorState.pushNamed(AppRoute.addDriver).then((value) async {
                                if (value != null) {
                                  await controller.getDriverList();
                                  controller.currentStep.value = 1;
                                }
                              });
                            },
                            label: 'Add Driver',
                          ),
                        ],
                      ),
                    ),
                    isActive: controller.currentStep.value == 0,
                    state: controller.arrDriver.value?.isEmpty ?? true ? StepState.indexed : StepState.complete,
                  ),
                  Step(
                    title: const Text("Truck"),
                    content: Column(
                      children: [
                        Text(
                          "Add your truck to start managing trips efficiently.",
                          textAlign: TextAlign.center,
                          style: bohibaTheme.textTheme.titleLarge,
                        ),
                        PrimaryButton(
                          height: 25.h,
                          width: ScreenUtils.width * 0.3,
                          onPressed: () {
                            navigatorState.pushNamed(AppRoute.addTruck).then((value) async {
                              if (value != null) {
                                await controller.getTruckList();
                                controller.currentStep.value = 2;
                              }
                            });
                          },
                          label: 'Add Truck',
                        ),
                      ],
                    ),
                    isActive: controller.currentStep.value == 1,
                    state: controller.arrTruck.value?.isEmpty ?? true ? StepState.indexed : StepState.complete,
                  ),
                  Step(
                    title: const Text("Trip"),
                    content: Column(
                      children: [
                        Text(
                          "Start keeping record of your trips with truck and driver data.",
                          textAlign: TextAlign.center,
                          style: bohibaTheme.textTheme.titleLarge,
                        ),
                        PrimaryButton(
                          height: 25.h,
                          width: ScreenUtils.width * 0.3,
                          onPressed: () {
                            navigatorState.pushNamed(AppRoute.addTrip).then((value) async {
                              if (value != null) {
                                await controller.getTruckList();
                              }
                            });
                          },
                          label: 'Add Trip',
                        ),
                      ],
                    ),
                    isActive: controller.currentStep.value == 2,
                    state: controller.arrTrip.value?.isEmpty ?? true ? StepState.indexed : StepState.complete,
                  ),
                ],
              ),
            ),
          );
        }
      }),
      driverWidget: Obx(() {
        if (controller.profile.value == null) {
          return SizedBox.shrink();
        } else if (controller.profile.value?.verified != 'verified') {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Container(
              width: ScreenUtils.width,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: bohibaTheme.cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    child: Icon(
                      Icons.verified_user_outlined,
                      size: 24.h,
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Complete your verification',
                          style: bohibaTheme.textTheme.labelLarge,
                        ),
                        Text(
                          'Get verified to unlock all your features and ensure account security.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: bohibaTheme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }
}

/*
if (step['serviceType'] == ServiceType.trip.name) {
                              navigatorState.pushNamed(AppRoute.addTrip);
                            } else if (step['serviceType'] ==
                                ServiceType.truck.name) {
                              navigatorState.pushNamed(AppRoute.addTruck);
                            } else if (step['serviceType'] ==
                                ServiceType.driver.name) {
                              navigatorState.pushNamed(AppRoute.addDriver);
                            } else {
                              return;
                            }

 */
