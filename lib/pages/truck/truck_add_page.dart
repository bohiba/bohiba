import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/controllers/truck_all_controller.dart';
import 'package:get/get.dart';
import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/theme/bohiba_theme.dart';

class AddTruckPage extends GetView<TruckAllController> {
  const AddTruckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: "Add Truck",
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your RC number",
                style: bohibaTheme.textTheme.titleLarge,
              ),
              TextInputField(
                prefixIcon: const Icon(Remix.truck_line),
                maxLength: 10,
                readOnly: false,
                hintText: "RC Number",
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.text,
                controller: controller.vehicleNumberController,
                onChanged: (v) {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          child: PrimaryButton(
            label: "VERIFY",
            onPressed: () => controller.createVehicle(
              vehicleNumber: controller.vehicleNumberController.text.trim(),
            ),
          ),
        ),
      ),
    );
  }
}

class ScanModeAddTruck extends GetView<TruckAllController> {
  const ScanModeAddTruck({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Scan Vehicle RC',
          style: bohibaTheme.textTheme.titleLarge,
        ),
        Text(
          'Use camera to auto-read RC details. If details fethced are not accurate please use manual mode',
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
            color: bohibaTheme.textTheme.titleSmall!.color,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 15.0.h, top: 10.h),
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            onPressed: () async {},
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text("Scan License / QR Code"),
          ),
        ),
      ],
    );
  }
}
