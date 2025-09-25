import 'dart:io';

import '/dist/component_exports.dart';
import '/controllers/image_upload_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/dist/app_enums.dart';
import '/pages/widget/app_divider.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

/// ------------------- Initial Upload State -------------------
class InitialImageUploadWidget<T extends ImageUploadController>
    extends GetView<T> {
  const InitialImageUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            await controller.pickImage(pickertype: PickerType.gallery);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: AspectRatio(
            aspectRatio: 16.h / 9.w,
            child: Container(
              decoration: TileDecorative(),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: bohibaTheme.dividerColor,
                    child: const Icon(EvaIcons.cloudUploadOutline),
                  ),
                  Gap(ScreenUtils.height10),
                  Text(
                    'Tap to upload photo',
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                      fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                      color: bohibaTheme.textTheme.bodySmall!.color,
                    ),
                  ),
                  Text(
                    'PNG or JPG (max. 400*400px)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                      fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                      color: bohibaTheme.textTheme.titleLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtils.height20,
            horizontal: ScreenUtils.width15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppDivider(width: ScreenUtils.width * 0.27),
              Text(
                'OR',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                  color: bohibaTheme.textTheme.bodyLarge!.color,
                ),
              ),
              AppDivider(width: ScreenUtils.width * 0.27),
            ],
          ),
        ),
        PrimaryButton(
          onPressed: () async {
            await controller.pickImage(pickertype: PickerType.camera);
          },
          width: ScreenUtils.width * 0.4,
          label: 'Open Camera',
        )
      ],
    );
  }
}

/// ------------------- Uploading State -------------------
class OnUploadingImageWidget<T extends ImageUploadController>
    extends GetView<T> {
  const OnUploadingImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: ScreenUtils.height * 0.1,
            width: 75,
            padding: EdgeInsets.only(bottom: ScreenUtils.height10),
            decoration: BoxDecoration(
              color: BohibaColors.lightGreyColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.bottomCenter,
            child: const Icon(Icons.image_rounded, size: 36),
          ),
          Gap(ScreenUtils.height10),
          Text(
            "${(controller.uploadPrgs.value * 100).toInt()} %",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
              fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
              color: bohibaTheme.textTheme.titleLarge!.color,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtils.height20,
              horizontal: ScreenUtils.width25,
            ),
            child: LinearProgressIndicator(
              value: controller.uploadPrgs.value,
              minHeight: 6,
              borderRadius: BorderRadius.circular(15.0),
              valueColor:
                  AlwaysStoppedAnimation<Color>(BohibaColors.primaryColor),
            ),
          ),
          Text(
            'Uploading Document...',
            style: TextStyle(
              fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
              fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
              color: bohibaTheme.textTheme.labelMedium!.color,
            ),
          ),
          Text(
            controller.imgName.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
              fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
              color: bohibaTheme.textTheme.titleLarge!.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------- Success State -------------------
class OnFetchingImageSuccessWidget<T extends ImageUploadController>
    extends GetView<T> {
  const OnFetchingImageSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: BohibaColors.successColor,
            child: Icon(
              Remix.checkbox_circle_fill,
              color: BohibaColors.white,
            ),
          ),
          Gap(ScreenUtils.height10),
          Text(
            'Upload Complete',
            style: TextStyle(
              fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
              fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
              color: BohibaColors.successColor,
            ),
          ),
          Text(
            controller.imgName.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
              fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
              color: bohibaTheme.textTheme.titleLarge!.color,
            ),
          ),
          Gap(ScreenUtils.height20),
          TextButton.icon(
            onPressed: () {
              if (controller.selectedImg != null) {
                controller.deleteImageFile(controller.selectedImg!);
              }
            },
            icon: Icon(
              EvaIcons.trash2Outline,
              color: BohibaColors.warningColor,
            ),
            label: Text(
              'Clear Upload',
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                color: BohibaColors.warningColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// ------------------- Error State -------------------
class OnFetchingImageErrorWidget<T extends ImageUploadController>
    extends GetView<T> {
  const OnFetchingImageErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () async {
            await controller.pickImage(pickertype: PickerType.gallery);
          },
          child: AspectRatio(
            aspectRatio: 16.h / 9.w,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: BohibaColors.tileColor,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: BohibaColors.warningColor,
                    child: Icon(
                      Icons.error_outlined,
                      color: BohibaColors.white,
                    ),
                  ),
                  Gap(ScreenUtils.height10),
                  Text(
                    'Retry Again, Tap to re-upload',
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                      fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                      color: BohibaColors.warningColor,
                    ),
                  ),
                  Text(
                    'PNG or JPG (max. 400*400px)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                      fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                      color: bohibaTheme.textTheme.titleLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtils.height20,
            horizontal: ScreenUtils.width15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppDivider(width: ScreenUtils.width * 0.27),
              Text(
                'OR',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                  color: bohibaTheme.textTheme.bodyLarge!.color,
                ),
              ),
              AppDivider(width: ScreenUtils.width * 0.27),
            ],
          ),
        ),
        PrimaryButton(
          onPressed: () async {
            await controller.pickImage(pickertype: PickerType.camera);
          },
          width: ScreenUtils.width * 0.4,
          label: 'Open Camera',
        )
      ],
    );
  }
}

class OnDocumentVerifiedWidget<T extends ImageUploadController>
    extends GetView<T> {
  final String title;
  final String description;
  final String? docPath;
  const OnDocumentVerifiedWidget({
    super.key,
    this.title = 'Document verified successfully',
    this.description =
        'Your document has been successfully verified by Bohiba and found to be authentic',
    this.docPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16.h / 9.w,
          child: Container(
            decoration: docPath != null || docPath!.isNotEmpty
                ? BoxDecoration(
                    color: BohibaColors.tileColor,
                    image: DecorationImage(
                      image: FileImage(
                        File(docPath!),
                      ),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      width: 2.0,
                      color: BohibaColors.tileColor,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  )
                : BoxDecoration(
                    color: BohibaColors.greyColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
          ),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_rounded,
              color: BohibaColors.successColor,
            ),
            Gap(5.w),
            Text(
              title,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                color: BohibaColors.successColor,
              ),
            ),
          ],
        ),
        Gap(5.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: bohibaTheme.textTheme.titleLarge!.color,
            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
          ),
        ),
        Spacer(),
      ],
    );
  }
}
