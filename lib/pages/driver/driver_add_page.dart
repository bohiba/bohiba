import '../../model/user_model.dart';

import '/pages/widget/required_label.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';

import '/controllers/driver_add_controller.dart';

import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_dropdown/primary_dropdown_menu.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
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
                                    controller.addAsset.value = change ?? AddAssetUsing.uuid;
                                  },
                                  child: Radio<AddAssetUsing>(
                                    value: AddAssetUsing.uuid,
                                  ),
                                ),
                                Text("UUID", style: bohibaTheme.textTheme.titleLarge),
                              ],
                            ),
                            Row(
                              children: [
                                RadioGroup(
                                  groupValue: controller.addAsset.value,
                                  onChanged: (AddAssetUsing? change) {
                                    controller.addAsset.value = change ?? AddAssetUsing.doc;
                                  },
                                  child: Radio<AddAssetUsing>(
                                    value: AddAssetUsing.doc,
                                  ),
                                ),
                                Text("Manual", style: bohibaTheme.textTheme.titleLarge),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (controller.addAsset.value == AddAssetUsing.uuid) UUIDDriverVerification() else ManualModeDriverVerification(),
                      Visibility(
                        visible: controller.arrTruck.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredLabel(label: 'Assign Truck'),
                            PrimaryDropDownMenu(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height10,
                              ),
                              hint: controller.truck.value.driverName ?? 'Registration Number',
                              items: controller.arrTruck.map((f) => f.regdNumber.toString()).toList(),
                              enableSearch: true,
                              focusOnTap: true,
                              onChanged: (p0) {
                                controller.strTruckRegdNo.value = p0 ?? '';
                                GlobalService.printHandler('ID: ${controller.strTruckRegdNo.value}');
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

class UUIDDriverVerification extends GetView<DriverAddController> {
  const UUIDDriverVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequiredLabel(label: 'UUID', required: true),
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
        RequiredLabel(label: 'Driving License', required: true),
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
        RequiredLabel(label: 'D.O.B', required: true),
        DateInputField(
          width: ScreenUtils.width,
          controller: controller.dateController,
          onTap: () async {
            DateTime? pickedDate = await GlobalService.datePickerModal(context: context);
            if (pickedDate != null) {
              controller.dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
            }
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
