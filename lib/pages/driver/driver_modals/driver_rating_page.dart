import '/controllers/driver_rating_controller.dart';

import '/component/screen_utils.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';

import '/theme/bohiba_theme.dart';
import '/pages/widget/required_label.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverRatingPage extends GetView<DriverRatingController> {
  const DriverRatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(title: 'Rate Driver'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.height10,
                left: ScreenUtils.width15,
                right: ScreenUtils.width15,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55.r,
                    backgroundColor: bohibaTheme.dividerColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      controller.driverModel.value?.profile?.name ?? '',
                      style: bohibaTheme.textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    "UUID: ${controller.driverModel.value?.profile?.driverUuid ?? ''}",
                    style: bohibaTheme.textTheme.titleLarge,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.h),
                    alignment: AlignmentGeometry.centerLeft,
                    child: RequiredLabel(label: 'Rate your exprience'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: ScreenUtils.height20),
                    child: StarRating(
                      size: 48.h,
                      rating: controller.rateStar.value,
                      allowHalfRating: true,
                      onRatingChanged: (rating) {
                        controller.rateStar.value = rating;
                      },
                      color: bohibaTheme.colorScheme.surface,
                      borderColor: bohibaTheme.colorScheme.secondary,
                      emptyIcon: Icons.star_border_rounded,
                      filledIcon: Icons.star_rounded,
                      halfFilledIcon: Icons.star_half_rounded,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.h),
                    alignment: AlignmentGeometry.centerLeft,
                    child: RequiredLabel(label: 'Leave a comment'),
                  ),
                  TextInputField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 7,
                    height: 115.h,
                    hintText: 'Write your review...',
                    nextActionType: TextInputAction.done,
                    controller: controller.feedbackCtrl,
                    onChanged: (value) {
                      if (value != controller.selectedRateMsgIndex.value) {
                        controller.isSelected.value = false;
                        controller.selectedRateMsgIndex.value = '';
                      }
                    },
                  ),
                  Wrap(
                    children: controller.suggestion.map((txt) {
                      controller.isSelected.value = controller.selectedRateMsgIndex.value == txt;
                      return Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: ChoiceChip(
                          label: Text(
                            txt,
                            style: TextStyle(
                              color: controller.selectedRateMsgIndex.value == txt ? bohibaTheme.colorScheme.surface : bohibaTheme.colorScheme.primary,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: controller.selectedRateMsgIndex.value == txt ? bohibaTheme.scaffoldBackgroundColor : bohibaTheme.colorScheme.primary),
                            borderRadius: BorderRadius.circular(8.0.h),
                          ),
                          selected: controller.isSelected.value,
                          onSelected: (value) {
                            controller.onSelectMsg(txt);
                          },
                          selectedColor: controller.selectedRateMsgIndex.value == txt ? bohibaTheme.colorScheme.primary : bohibaTheme.scaffoldBackgroundColor,
                          backgroundColor: controller.selectedRateMsgIndex.value == txt ? bohibaTheme.colorScheme.primary : bohibaTheme.scaffoldBackgroundColor,
                        ),
                      );
                    }).toList(),
                  ),
                  Visibility(
                    visible: controller.didReviewed.isFalse,
                    child: PrimaryButton(
                        padding: EdgeInsets.only(top: 10.h, bottom: 35.h),
                        label: 'RATE',
                        onPressed: () async {
                          int v = await controller.rateDriver(
                            txtUuid: controller.driverModel.value!.profile!.driverUuid!,
                            rating: controller.rateStar.value,
                            txtFeedback: controller.feedbackCtrl.text.trim(),
                          );

                          if (v > 1) {
                            navigateState.pop();
                          }
                        }),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
