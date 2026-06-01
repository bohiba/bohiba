import '../../component/bohiba_dropdown/app_search_dropdown_button.dart';
import '/dist/component_exports.dart';
import '/extensions/bohiba_extension.dart';

import '/controllers/add_trip_document_controller.dart';
import '/component/bohiba_buttons/primary_button.dart';

import '/component/image_upload_widget.dart';
import '../../dist/enums/app_enums.dart';
import '/theme/bohiba_theme.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddTripDocumentPage extends GetView<AddTripDocumentController> {
  final String label;
  const AddTripDocumentPage({super.key, this.label = ''});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Widget content = SizedBox();
      UploadStatus checkStatus = controller.status.value;
      if (checkStatus == UploadStatus.initial) {
        content = InitialImageUploadWidget<AddTripDocumentController>();
      } else if (checkStatus == UploadStatus.uploading) {
        content = OnUploadingImageWidget<AddTripDocumentController>();
      } else if (checkStatus == UploadStatus.success) {
        content = OnFetchingImageSuccessWidget<AddTripDocumentController>();
      } else if (checkStatus == UploadStatus.failure) {
        content = OnFetchingImageErrorWidget<AddTripDocumentController>();
      } else {
        content = SizedBox();
      }
      return Scaffold(
        appBar: TitleAppbar(title: 'Trip Document'),
        body: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upload your Document',
                  style: bohibaTheme.textTheme.displayMedium,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Access when you need in future.',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                ),
              ),
              content,
              AppDropdownSearch(
                menuHeight: ScreenUtils.height * 0.20,
                hint: 'Choose Document type',
                items: [
                  'challan',
                  'e-way_bill',
                  'fuel_bill',
                  'toll_receipt',
                  'weighbridge_slip',
                  'rto_receipt',
                  'other'
                ],
                labelBuilder: (String p1) {
                  return p1.toCapitalizedLabel();
                },
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom),
                child: PrimaryButton(
                  onPressed: () async => await controller.addDocument(),
                  label: 'Save',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
