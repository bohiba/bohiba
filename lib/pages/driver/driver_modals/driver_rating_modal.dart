import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_colors.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/screen_utils.dart';
import '/controllers/driver_controller.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class DriverRatingModal extends GetView<DriverController> {
  const DriverRatingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: (ScreenUtils.height * 0.35).h,
        padding: EdgeInsets.only(
          top: ScreenUtils.height20,
          left: ScreenUtils.width15,
          right: ScreenUtils.width15,
        ),
        decoration: BoxDecoration(
          color: BohibaColors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.0.r),
            topLeft: Radius.circular(12.0.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rate your exprience with ${controller.driverModel.value.profile?.name ?? ''}',
                  style: bohibaTheme.textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: () => controller.onModalClose(),
                  icon: Icon(Remix.close_line),
                ),
              ],
            ),
            Obx(
              () {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: ScreenUtils.height5),
                  child: StarRating(
                    size: 48.h,
                    rating: controller.rateStar.value,
                    allowHalfRating: true,
                    onRatingChanged: (rating) {
                      controller.rateStar.value = rating;
                    },
                    borderColor: BohibaColors.greyColor,
                    emptyIcon: Icons.star_border_rounded,
                    filledIcon: Icons.star_rounded,
                    halfFilledIcon: Icons.star_half_rounded,
                  ),
                );
              },
            ),
            TextInputField(
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              height: 115.h,
              hintText: 'Write your review...',
              controller: controller.feedbackCtrl,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtils.height5, bottom: ScreenUtils.height10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.suggestion.length,
                      (index) {
                        return GestureDetector(
                          onTap: () => controller.onSelectMsg(index),
                          child: Container(
                            padding: EdgeInsets.all(5.h),
                            margin: EdgeInsets.only(right: 8.h),
                            decoration: BoxDecoration(
                              color:
                                  controller.selectedRateMsgIndex.value == index
                                      ? BohibaColors.primaryColor
                                      : BohibaColors.transparent,
                              border:
                                  Border.all(color: BohibaColors.primaryColor),
                              borderRadius: BorderRadius.circular(8.0.h),
                            ),
                            child: Text(
                              controller.suggestion[index],
                              style: TextStyle(
                                color: controller.selectedRateMsgIndex.value ==
                                        index
                                    ? BohibaColors.white
                                    : BohibaColors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
            Visibility(
              visible: controller.didReviewed.isFalse,
              child: PrimaryButton(
                label: 'RATE',
                onPressed: () => controller.rateDriver(
                  txtUuid: controller.driverModel.value.profile!.driverUuid!,
                  rating: controller.rateStar.value,
                  txtFeedback: controller.feedbackCtrl.text.trim(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
