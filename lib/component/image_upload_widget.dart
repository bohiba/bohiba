import '/dist/component_exports.dart';
import '/controllers/image_upload_controller.dart';
import '/component/bohiba_buttons/secoundary_button.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/dist/app_enums.dart';
import '/pages/widget/app_divider.dart';
import '/theme/bohiba_theme.dart';

import 'dart:io';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ------------------- Initial Upload State -------------------
class InitialImageUploadWidget<T extends ImageUploadController> extends GetView<T> {
  const InitialImageUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(vertical: ScreenUtils.height30),
      constraints: BoxConstraints(
        minHeight: ScreenUtils.height * 0.35,
      ),
      decoration: ShapeDecoration(
        shape: DashedBorder(
          radius: 12.0,
          width: 1.5,
          color: bohibaTheme.dividerColor,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      alignment: Alignment.center,
      child: Column(
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
      ),
    );
  }
}

/// ------------------- Uploading State -------------------
class OnUploadingImageWidget<T extends ImageUploadController> extends GetView<T> {
  const OnUploadingImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(vertical: ScreenUtils.height30),
        constraints: BoxConstraints(
          minHeight: ScreenUtils.height * 0.35,
        ),
        decoration: ShapeDecoration(
          shape: DashedBorder(
            radius: 12.0,
            width: 1.5,
            color: bohibaTheme.dividerColor,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
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
                valueColor: AlwaysStoppedAnimation<Color>(BohibaColors.primaryColor),
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
      ),
    );
  }
}

/// ------------------- Success State -------------------
class OnFetchingImageSuccessWidget<T extends ImageUploadController> extends GetView<T> {
  const OnFetchingImageSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(vertical: ScreenUtils.height30),
          constraints: BoxConstraints(
            minHeight: ScreenUtils.height * 0.35,
          ),
          decoration: ShapeDecoration(
            image: controller.selectedImg.value == null
                ? null
                : DecorationImage(
                    image: FileImage(
                      File.fromUri(
                        Uri.file(controller.selectedImg.value!.path),
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
            shape: DashedBorder(
              radius: 12.0,
              width: 1.5,
              color: bohibaTheme.dividerColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.deleteImageFile(controller.selectedImg.value!);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                EvaIcons.trash2Outline,
                color: bohibaTheme.colorScheme.error,
              ),
              Gap(10.w),
              Text(
                'Discard Upload',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                  fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                  color: bohibaTheme.colorScheme.error,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

/// ------------------- Error State -------------------
class OnFetchingImageErrorWidget<T extends ImageUploadController> extends GetView<T> {
  const OnFetchingImageErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(vertical: ScreenUtils.height30),
      constraints: BoxConstraints(
        minHeight: ScreenUtils.height * 0.35,
      ),
      decoration: ShapeDecoration(
        shape: DashedBorder(
          radius: 12.0,
          width: 1.5,
          color: bohibaTheme.dividerColor,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Column(
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
      ),
    );
  }
}

class OnDocumentVerifiedWidget<T extends ImageUploadController> extends GetView<T> {
  final String title;
  final String description;
  final String? docPath;
  const OnDocumentVerifiedWidget({
    super.key,
    this.title = 'Document verified successfully',
    this.description = 'Your document has been successfully verified by Bohiba and found to be authentic',
    this.docPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(vertical: ScreenUtils.height30),
          constraints: BoxConstraints(
            minHeight: ScreenUtils.height * 0.35,
          ),
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

class EditImageWidget<T extends ImageUploadController> extends GetView<T> {
  const EditImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Container(
            width: double.maxFinite,
            height: ScreenUtils.height * 0.35,
            constraints: BoxConstraints(
              minHeight: ScreenUtils.height * 0.35,
              maxHeight: ScreenUtils.height * 0.55,
            ),
            margin: EdgeInsets.only(top: ScreenUtils.height30, bottom: ScreenUtils.height15),
            decoration: ShapeDecoration(
              shape: DashedBorder(
                radius: 12.0,
                width: 1.5,
                color: bohibaTheme.dividerColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              color: Colors.white60,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SecoundaryButton(
                onPressed: () => controller.deleteImageFile(controller.selectedImg.value!),
                label: 'Delete Image',
                textColor: bohibaTheme.colorScheme.surface,
                color: bohibaTheme.colorScheme.error,
              ),
              PrimaryButton(
                width: 120.w,
                onPressed: () => controller.pickImage(pickertype: PickerType.gallery),
                label: 'Upload other',
              )
            ],
          ),
        ],
      ),
    );
  }
}
