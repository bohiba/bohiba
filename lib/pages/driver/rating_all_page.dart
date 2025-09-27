import '/model/rating_model.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/controllers/driver_controller.dart';
import '/model/driver_model.dart';
import '/pages/driver/driver_modals/driver_rating_modal.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class RatingAllPage extends GetView<DriverController> {
  const RatingAllPage({super.key});

  @override
  Widget build(context) {
    return Obx(() {
      DriverModel driver = controller.driverModel.value;
      return Scaffold(
          appBar: TitleAppbar(
            title: driver.profile?.name ?? 'NA',
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: controller.driverModel.value.rating != null ||
                          controller.driverModel.value.rating!.isNotEmpty
                      ? ListView.builder(
                          itemCount:
                              controller.driverModel.value.rating?.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            RatingModel driverModelRating =
                                controller.driverModel.value.rating![index];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtils.height5,
                                  horizontal: ScreenUtils.width15),
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height5,
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 15.w,
                                    backgroundColor: bohibaTheme.dividerColor,
                                  ),
                                  Gap(8.w),
                                  SizedBox(
                                    width: ScreenUtils.width * 0.45.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          driverModelRating.reviewer?.name ??
                                              'NA',
                                          style:
                                              bohibaTheme.textTheme.labelLarge,
                                        ),
                                        ReadMoreText(
                                          driverModelRating.feedback ?? '',
                                          trimLines: 2,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: ' Read more',
                                          trimExpandedText: ' Show less',
                                          style: TextStyle(
                                            fontSize: bohibaTheme.textTheme
                                                .labelMedium!.fontSize,
                                            color: bohibaTheme
                                                .textTheme.titleMedium!.color,
                                          ),
                                          moreStyle: TextStyle(
                                            fontSize: bohibaTheme.textTheme
                                                .labelMedium!.fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                          lessStyle: TextStyle(
                                            fontSize: bohibaTheme.textTheme
                                                .labelMedium!.fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 35.h,
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          driverModelRating.rating
                                                  ?.toString() ??
                                              '0',
                                          style:
                                              bohibaTheme.textTheme.labelLarge,
                                        ),
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : SizedBox.shrink(),
                ),
                controller.didReviewed.isFalse
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(
                          left: ScreenUtils.width15,
                          right: ScreenUtils.width15,
                        ),
                        child: PrimaryButton(
                          label: 'Rate Driver',
                          onPressed: () => showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: false,
                            enableDrag: false,
                            shape: BottomModalShape(),
                            context: context,
                            builder: (context) {
                              return DriverRatingModal();
                            },
                          ).then((onValue) async {
                            if (onValue != null) {
                              await controller.updateDriverInfo(
                                id: controller.driverModel.value.id!.toString(),
                              );
                            }
                          }),
                        ),
                      ),
              ],
            ),
          ));
    });
  }
}
