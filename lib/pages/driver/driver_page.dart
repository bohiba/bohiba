import '/model/rating_model.dart';

import '/component/bohiba_appbar/driver_appbar.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/pages/driver/driver_modals/driver_rating_modal.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import '/controllers/driver_controller.dart';
import '/extensions/bohiba_extension.dart';
import '/pages/widget/detail_box_widget.dart';
import '/pages/widget/linear_box_widget.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/theme/bohiba_theme.dart';
import '/dist/component_exports.dart';
import 'package:flutter/material.dart';

class DriverPage extends GetView<DriverController> {
  const DriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigate = Navigator.of(context);
    return Obx(() {
      return Scaffold(
        appBar: DriverAppbar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ScreenUtils.width,
                  height: ScreenUtils.height * 0.3,
                  // color: BohibaColors.borderColor,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        GlobalService.getAvatarUrl(
                          controller.driverModel.value.profile?.name ?? '',
                          rounded: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtils.height10,
                    left: ScreenUtils.height15,
                    right: ScreenUtils.height15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Personal Details",
                        style: bohibaTheme.textTheme.headlineMedium,
                      ),
                      Gap(ScreenUtils.width5),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            DetailsBox(
                              headline: 'UUID',
                              title: controller
                                      .driverModel.value.profile?.driverUuid ??
                                  'NA',
                            ),
                            DetailsBox(
                              headline: 'Role',
                              title: (controller
                                      .driverModel.value.profile?.roleId
                                      ?.roleName()) ??
                                  'NA',
                            ),
                            DetailsBox(
                              headline: 'Status',
                              title: controller
                                      .driverModel.value.profile?.isActive
                                      .toString()
                                      .toUpperCase() ??
                                  'NA',
                            ),
                            DetailsBox(
                              headline: 'Last Sync',
                              title: controller.driverModel.value.updatedAt ??
                                  'NA',
                            ),
                            DetailsBox(
                              headline: 'D.O.B',
                              title:
                                  controller.driverModel.value.profile?.dob ??
                                      'NA',
                            ),
                            DetailsBox(
                              headline: 'Phone',
                              title: controller.driverModel.value.profile
                                      ?.mobileNumber ??
                                  'NA',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtils.height20),
                        child: Text(
                          'License & Vehicle Details',
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                      ),
                      LinearBoxWidget(
                        header: 'Driving License',
                        title: controller.driverModel.value.licenseDetail
                                ?.licenseNumber ??
                            'NA',
                      ),
                      LinearBoxWidget(
                        header: 'License Status',
                        title: controller
                                .driverModel.value.licenseDetail?.status
                                .toString()
                                .toUpperCase() ??
                            'NA',
                      ),
                      LinearBoxWidget(
                        header: 'COV',
                        title: 'NA',
                      ),
                      LinearBoxWidget(
                        header: 'Issued',
                        title: controller.driverModel.value.licenseDetail
                                ?.validityFrom ??
                            'NA',
                      ),
                      LinearBoxWidget(
                        header: 'Expiry',
                        title: controller.driverModel.value.licenseDetail
                                ?.validityTill ??
                            'NA',
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: controller.driverModel.value.rating == null ||
                          controller.driverModel.value.rating!.isEmpty
                      ? false
                      : true,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtils.height20,
                      left: ScreenUtils.width15,
                      right: ScreenUtils.width15,
                      bottom: ScreenUtils.height10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rating",
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            navigate.pushNamed(AppRoute.allRating);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ScreenUtils.height5,
                            ),
                            child: Text(
                              "See All",
                              style: TextStyle(
                                fontSize: bohibaTheme
                                    .textTheme.headlineMedium!.fontSize,
                                color: bohibaTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: ScreenUtils.height25),
                  alignment: Alignment.center,
                  child: controller.driverModel.value.rating != null
                      ? ListView.builder(
                          itemCount:
                              controller.driverModel.value.rating!.length >= 3
                                  ? 3
                                  : controller.driverModel.value.rating?.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            RatingModel ratingModel =
                                controller.driverModel.value.rating![index];
                            return Container(
                              margin:
                                  EdgeInsets.only(bottom: ScreenUtils.height10),
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtils.width15,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 15.w,
                                    backgroundColor: bohibaTheme.dividerColor,
                                  ),
                                  Gap(8.w),
                                  SizedBox(
                                    width: ScreenUtils.width * 0.55.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ratingModel.reviewer?.name ?? 'NA',
                                          style:
                                              bohibaTheme.textTheme.labelLarge,
                                        ),
                                        ReadMoreText(
                                          ratingModel.feedback ?? '',
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
                                            color: bohibaTheme.primaryColor,
                                          ),
                                          lessStyle: TextStyle(
                                            fontSize: bohibaTheme.textTheme
                                                .labelMedium!.fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: bohibaTheme.primaryColor,
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
                                          ratingModel.rating?.toString() ?? '0',
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
                      : Container(),
                ),
                controller.didReviewed.isTrue
                    ? SizedBox()
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
                          ).then(
                            (onValue) async {
                              if (onValue != null) {
                                await controller.updateDriverInfo(
                                  id: controller.driverModel.value.id!
                                      .toString(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
