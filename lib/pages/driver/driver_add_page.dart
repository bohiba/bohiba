import 'package:bohiba/component/bohiba_dropdown/app_search_dropdown_button.dart';

import 'driver_uuid_verification.dart';
import 'driver_verification_manual_mode.dart';

import '/model/user_model.dart';

import '/pages/widget/required_label.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';

import '/controllers/driver_add_controller.dart';

import '/dist/enums/app_enums.dart';
import '/dist/component_exports.dart';
import '/component/bohiba_buttons/primary_button.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

class DriverAddPage extends GetView<DriverAddController> {
  const DriverAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: TitleAppbar(
          title: "Add Driver",
          popResult: controller.popResult.value,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height10,
              left: ScreenUtils.width15,
              right: ScreenUtils.width15,
              // bottom: ScreenUtils.height10,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: ScreenUtils.height10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                RadioGroup(
                                  groupValue: controller.addAsset.value,
                                  onChanged: (AddAssetUsing? change) {
                                    controller.addAsset.value =
                                        change ?? AddAssetUsing.uuid;
                                  },
                                  child: Radio<AddAssetUsing>(
                                    value: AddAssetUsing.uuid,
                                  ),
                                ),
                                Text("UUID",
                                    style: bohibaTheme.textTheme.titleLarge),
                              ],
                            ),
                            Row(
                              children: [
                                RadioGroup(
                                  groupValue: controller.addAsset.value,
                                  onChanged: (AddAssetUsing? change) {
                                    controller.addAsset.value =
                                        change ?? AddAssetUsing.doc;
                                  },
                                  child: Radio<AddAssetUsing>(
                                    value: AddAssetUsing.doc,
                                  ),
                                ),
                                Text("Manual",
                                    style: bohibaTheme.textTheme.titleLarge),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (controller.addAsset.value == AddAssetUsing.uuid)
                        UUIDDriverVerification()
                      else
                        ManualModeDriverVerification(),
                      Visibility(
                        visible: controller.arrTruck.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredLabel(label: 'Assign Truck'),
                            AppDropdownSearch<String>(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height10,
                              ),
                              hint: controller.truck.value.driverName ??
                                  'Registration Number',
                              items: controller.arrTruck
                                  .map((f) => f.regdNumber.toString())
                                  .toList(),
                              enableSearch: true,
                              labelBuilder: (p1) {
                                return p1;
                              },
                              onChanged: (p0) {
                                controller.strTruckRegdNo.value = p0 ?? '';
                                GlobalService.printHandler(
                                    'ID: ${controller.strTruckRegdNo.value}');
                                GlobalService.closeKeyboard();
                              },
                              menuController: controller.assignTruckCtlr,
                            ),
                          ],
                        ),
                      ),
                      // Text('Assign Truck', style: bohibaTheme.textTheme.titleLarge),
                    ],
                  ),
                ),
                PrimaryButton(
                  label: "Add Driver",
                  onPressed: () async {
                    UserModel? driver = await controller.addDriver();
                    if (driver != null) {
                      navigatorState.pop(true);
                    }
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

class ScanModeDLVerification extends GetView<DriverAddController> {
  final Widget child;
  const ScanModeDLVerification({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scan Driver’s License',
          style: bohibaTheme.textTheme.titleLarge,
        ),
        Text(
          'Use camera to auto-read DL details.',
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
            color: bohibaTheme.textTheme.titleSmall!.color,
          ),
        ),
        Container(
          height: ScreenUtils.height * 0.40,
          width: double.maxFinite,
          margin: EdgeInsets.only(
            top: ScreenUtils.height10,
            bottom: ScreenUtils.height25,
          ),
          padding: EdgeInsets.all(ScreenUtils.height5),
          decoration: ShapeDecoration(
            shape: DashedBorder(
              radius: 12.0,
              width: 1.5,
              color: BohibaColors.borderColor,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
