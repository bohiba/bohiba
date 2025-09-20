import 'package:auto_size_text/auto_size_text.dart';
import '/controllers/trip_add_controller.dart';
import 'package:get/get.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_dropdown/primary_dropdown_menu.dart';
import '/component/bohiba_appbar/appbar_icon.dart';
import '/component/bohiba_colors.dart';
import '/component/image_upload_widget.dart';
import '/component/screen_utils.dart';
import '/dist/app_enums.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:widgets_easier/widgets_easier.dart';

class AddDocumentPage extends GetView<TripAddController> {
  final String label;
  const AddDocumentPage({super.key, this.label = ''});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Widget content = SizedBox();
      UploadStatus checkStatus = controller.status.value;
      if (checkStatus == UploadStatus.initial) {
        content = InitialImageUploadWidget<TripAddController>();
      } else if (checkStatus == UploadStatus.uploading) {
        content = OnUploadingImageWidget<TripAddController>();
      } else if (checkStatus == UploadStatus.success) {
        content = OnFetchingImageSuccessWidget<TripAddController>();
      } else if (checkStatus == UploadStatus.failure) {
        content = OnFetchingImageErrorWidget<TripAddController>();
      } else {
        content = SizedBox();
      }
      return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: ScreenUtils.width * 0.45,
            child: AutoSizeText(
              label,
              maxLines: 1,
              style: bohibaTheme.appBarTheme.titleTextStyle,
              overflowReplacement: MarqueeText(
                speed: 10,
                alwaysScroll: true,
                style: bohibaTheme.appBarTheme.titleTextStyle,
                text: TextSpan(
                  text: label,
                ),
              ),
            ),
          ),
          actions: [
            AppBarIconBox(
              icon: Visibility(
                visible: controller.arrDoc.isNotEmpty,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: BohibaColors.primaryColor,
                  child: Text(
                    '${controller.arrDoc.length}',
                    style: TextStyle(
                        fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.headlineLarge!.fontWeight,
                        color: BohibaColors.white),
                  ),
                ),
              ),
            )
          ],
        ),
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
              Container(
                height: ScreenUtils.height * 0.40,
                width: ScreenUtils.width,
                margin: EdgeInsets.symmetric(vertical: ScreenUtils.height30),
                decoration: ShapeDecoration(
                  shape: DashedBorder(
                    radius: 12.0,
                    width: 1.5,
                    color: BohibaColors.borderColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: content,
              ),
              PrimaryDropDownMenu(
                width: ScreenUtils.width,
                menuHeight: ScreenUtils.height * 0.20,
                hint: 'Choose Document type',
                items: [
                  'Challan',
                  'E-Way Bill',
                  'Fuel Bill',
                  'Toll Receipt',
                  'Weighbridge Slip',
                  'RTO Receipt',
                  'Other'
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom),
                child: PrimaryButton(
                  onPressed: () {},
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
