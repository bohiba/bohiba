import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_buttons/secoundary_button.dart';
import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/controllers/location_controller.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllLocationModal extends StatelessWidget {
  const AllLocationModal({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController controller = Get.put(LocationController());
    return SafeArea(
      child: Container(
        width: ScreenUtils.width,
        constraints: BoxConstraints(minHeight: 75.h),
        decoration: BoxDecoration(
          color: bohibaTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.0.r),
            topLeft: Radius.circular(12.0.r),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 10.h,
                left: 15.w,
                right: 15.w,
                bottom: 10.h,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select matched location',
                        style: bohibaTheme.textTheme.headlineLarge,
                      ),
                      Text(
                        'Please confirm the most accurate address from the list.',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleSmall!.color,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.back(
                          result: controller.selectedIndex.value == -1
                              ? null
                              : controller
                                  .arrLocation[controller.selectedIndex.value]);
                      controller.selectedIndex.value = -1;
                    },
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                        fontSize:
                            bohibaTheme.textTheme.headlineMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.headlineMedium!.fontWeight,
                        color: bohibaTheme.colorScheme.error,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.arrLocation.isEmpty) {
                  return SizedBox(
                    width: ScreenUtils.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.userTitleMsg.value,
                          style: bohibaTheme.textTheme.headlineLarge,
                        ),
                        SizedBox(
                          width: ScreenUtils.width * 0.6,
                          child: Text(
                            controller.userSubTitle.value,
                            textAlign: TextAlign.center,
                            style: bohibaTheme.textTheme.titleMedium,
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.arrLocation.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> locObj =
                          controller.arrLocation[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtils.height10, left: 15.w, right: 15.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: BohibaColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 15.w),
                          height: 75,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                    '${locObj['name']}, ${locObj['locality']}, ${locObj['street']}, ${locObj['city']}, ${locObj['district']}, ${locObj['state']}, ${locObj['pincode']}, ${locObj['country']}'),
                              ),
                              Radio.adaptive(
                                value: index,
                                groupValue: controller.selectedIndex.value,
                                toggleable: true,
                                onChanged: (v) {
                                  if (v == null) {
                                    controller.selectedIndex.value = -1;
                                    return;
                                  }
                                  controller.selectAddress(v);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SecoundaryButton(
                    width: ScreenUtils.width / 2.3,
                    onPressed: () async {
                      controller.selectedIndex.value = -1;
                      await controller.getCurrentAddress();
                    },
                    label: 'Refresh',
                  ),
                  PrimaryButton(
                    onPressed: () {
                      if (controller.arrLocation.isEmpty) {
                        Get.back();
                        return;
                      }
                      Get.back(
                        result: controller.selectedIndex.value == -1
                            ? null
                            : controller
                                .arrLocation[controller.selectedIndex.value],
                      );
                      controller.selectedIndex.value = -1;
                    },
                    label: controller.arrLocation.isEmpty ? 'Close' : 'Save',
                    color: controller.arrLocation.isEmpty
                        ? bohibaTheme.colorScheme.error
                        : bohibaTheme.primaryColor,
                    width: ScreenUtils.width / 2.3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
