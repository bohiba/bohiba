import 'package:widgets_easier/widgets_easier.dart';

import '/component/bohiba_dropdown/app_dropdown_button.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:intl/intl.dart';

import '/controllers/driver_add_controller.dart';
import 'package:get/get.dart';
import '/dist/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '/dist/component_exports.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_buttons/primary_button.dart';

class DriverAddPage extends GetView<DriverAddController> {
  const DriverAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: TitleAppbar(title: "Add Driver"),
      body: SafeArea(
        child: Obx(
          () {
            return Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.height10,
                left: ScreenUtils.width15,
                right: ScreenUtils.width15,
                // bottom: ScreenUtils.height10,
              ),
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
                            Radio<AddAssetUsing>(
                              value: AddAssetUsing.uuid,
                              groupValue: controller.addAsset.value,
                              onChanged: (AddAssetUsing? change) {
                                controller.addAsset.value =
                                    change ?? AddAssetUsing.uuid;
                              },
                            ),
                            Text("UUID",
                                style: bohibaTheme.textTheme.titleLarge),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<AddAssetUsing>(
                              value: AddAssetUsing.doc,
                              groupValue: controller.addAsset.value,
                              onChanged: (AddAssetUsing? change) {
                                controller.addAsset.value =
                                    change ?? AddAssetUsing.doc;
                              },
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
                  Text('Assign Truck', style: bohibaTheme.textTheme.titleLarge),
                  AppDropdown(
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenUtils.height10,
                    ),
                    hint: controller.truck.value.driver?.name ??
                        'Registration Number',
                    items: controller.arrTruck.value,
                    labelBuilder: (truck) => truck.regdNumber!,
                    onChanged: (p0) {
                      controller.strTruckRegdNo.value = p0?.regdNumber ?? '';
                      GlobalService.printHandler(
                          'ID: ${controller.strTruckRegdNo.value}');
                      GlobalService.closeKeyboard();
                    },
                    menuController: controller.assignTruckCtlr,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height10,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          child: PrimaryButton(
            label: "Add Driver",
            onPressed: () async {
              final isUuidFlow =
                  controller.addAsset.value == AddAssetUsing.uuid;
              final isDocFlow = controller.addAsset.value == AddAssetUsing.doc;

              Map<String, dynamic>? bodyObj;

              // UUID Flow
              if (isUuidFlow) {
                final uuid = controller.uuidCtlr.text.trim();

                if (uuid.isEmpty) {
                  GlobalService.showAppToast(
                      message: 'Please provide driver UUID');
                  return;
                }
                if (uuid.length != 6) {
                  GlobalService.showAppToast(
                      message: 'Please provide valid UUID');
                  return;
                }

                bodyObj = {
                  'driver_uuid': uuid,
                  'type': 1,
                };
              }

              // Document Flow
              if (isDocFlow) {
                final dl = controller.licenseCtrl.text.trim();
                final dob = controller.dateController.text.trim();

                if (dl.isEmpty) {
                  GlobalService.showAppToast(
                      message: 'Please provide driver DL Number');
                  return;
                }
                if (dl.length != 16) {
                  GlobalService.showAppToast(
                      message: 'Please provide valid DL Number');
                  return;
                }
                if (dob.isEmpty) {
                  GlobalService.showAppToast(message: 'Please provide D.O.B');
                  return;
                }

                bodyObj = {
                  'license_number': dl,
                  'dob': dob,
                  'type': 0,
                };
              }

              // Final API Call
              if (bodyObj != null) {
                await controller.addDriver(bodyMap: bodyObj);
              }
            },
          ),
        ),
      ),
    );
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

class UUIDDriverVerification extends GetView<DriverAddController> {
  const UUIDDriverVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Driver UUID',
          style: bohibaTheme.textTheme.titleLarge,
        ),
        TextInputField(
          prefixIcon: const Icon(
            Remix.user_3_fill,
            size: 20,
          ),
          maxLength: 6,
          hintText: "6-digit UUID",
          textCapitalization: TextCapitalization.characters,
          controller: controller.uuidCtlr,
        ),
      ],
    );
  }
}

class ManualModeDriverVerification extends GetView<DriverAddController> {
  const ManualModeDriverVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Driving License',
          style: bohibaTheme.textTheme.titleLarge,
        ),
        Text(
          'Enter 10-digit unique number.',
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
            color: bohibaTheme.textTheme.titleSmall!.color,
          ),
        ),
        TextInputField(
          prefixIcon: const Icon(
            Remix.user_3_fill,
            size: 20,
          ),
          hintText: "License Number",
          textCapitalization: TextCapitalization.characters,
          maxLength: 16,
        ),
        Text(
          'D.O.B',
          style: bohibaTheme.textTheme.titleLarge,
        ),
        DateInputField(
          width: ScreenUtils.width,
          controller: controller.dateController,
          onTap: () async {
            DateTime pickedDate =
                await GlobalService.datePickerModal(context: context);
            controller.dateController.text =
                DateFormat('dd-MM-yyyy').format(pickedDate);
          },
          hintText: "D.O.B",
        ),
      ],
    );
  }
}

/*Widget content;
          switch (controller.status.value) {
            case UploadStatus.initial:
              content = InitialImageUploadWidget<DriverAddController>();
              break;
            case UploadStatus.uploading:
              content = OnUploadingImageWidget<DriverAddController>();
              break;
            case UploadStatus.success:
              content = OnFetchingImageSuccessWidget<DriverAddController>();
              break;
            case UploadStatus.failure:
              content = OnFetchingImageErrorWidget<DriverAddController>();
              break;
            case UploadStatus.verified:
              content = OnDocumentVerifiedWidget(
                title: 'Driving Liecense Verified Successfully',
                docPath: controller.imagePath.value,
              );
          }*/
