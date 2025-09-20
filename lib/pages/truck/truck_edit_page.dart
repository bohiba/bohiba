import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '../../component/bohiba_dropdown/app_dropdown_button.dart';
import '/services/global_service.dart';
import '/controllers/truck_edit_controller.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';

class TruckEditPage extends GetView<EditTruckController> {
  const TruckEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(title: 'Edit Truck'),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height10,
              left: ScreenUtils.width15,
              right: ScreenUtils.width15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select to assign driver",
                  style: bohibaTheme.textTheme.headlineMedium,
                ),
                Gap(ScreenUtils.width5),
                AppDropdown(
                  hint: controller.truck.value.driver?.name ?? 'Select driver',
                  items: controller.arrDriver.value,
                  labelBuilder: (driver) => driver.profile!.name!,
                  onChanged: (p0) {
                    controller.strDriverUuid.value = p0!.profile!.driverUuid!;
                    GlobalService.printHandler(
                        'ID: ${controller.strDriverUuid.value}');
                  },
                  menuController: controller.assignDriverCtlr,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenUtils.height20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sync truck value info',
                        style: bohibaTheme.textTheme.headlineMedium,
                      ),
                      RotationTransition(
                        turns: controller.rotationController,
                        child: GestureDetector(
                          onTap: () => controller.toggleRotation(),
                          child: const Icon(Remix.loop_right_line),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                PrimaryButton(
                  onPressed: () async => await controller.assignDriver(
                    driverUuid: controller.strDriverUuid.value,
                    regdNumber: controller.truck.value.regdNumber!,
                  ),
                  label: 'Assign Driver',
                ),
                PrimaryButton(
                  label: 'Remove Driver',
                  color: BohibaColors.warningColor,
                  onPressed: controller.isDriverAssigned.isFalse
                      ? null
                      : () async {
                          if (controller.truck.value.registration == null) {
                            return;
                          }
                          await controller.removeDriver(
                            regdNumber: controller.truck.value.regdNumber!,
                            id: controller.truck.value.id.toString(),
                          );
                        },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
