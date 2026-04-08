import '/dist/enums/app_enums.dart';
import '/theme/bohiba_theme.dart';
import '/routes/app_route.dart';
import '/model/rating_model.dart';
import '/services/launcher_service.dart';
import '/extensions/bohiba_extension.dart';

import '/component/image_path.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_appbar/driver_appbar.dart';
import '/component/bohiba_buttons/primary_button.dart';

import '/controllers/driver_controller.dart';
import '/pages/widget/linear_box_widget.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '/component/bohiba_text/bohiba_marquee_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DriverPage extends GetView<DriverController> {
  const DriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigate = Navigator.of(context);
    RefreshController refreshPageController = RefreshController();
    return Obx(() {
      return Scaffold(
        appBar: DriverAppbar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                  controller: refreshPageController,
                  onRefresh: () async {
                    await controller.getDriverInfo(methodType: MethodType.api);
                    controller.isRated();
                    refreshPageController.refreshCompleted();
                  },
                  child: (controller.driverModel.value == null)
                      ? Container(
                          height: ScreenUtils.height,
                          width: ScreenUtils.width,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                controller.strErrorTitle.value,
                                style: bohibaTheme.textTheme.headlineMedium,
                              ),
                              Text(
                                controller.strErrorDesc.value,
                                textAlign: TextAlign.center,
                                style: bohibaTheme.textTheme.titleMedium,
                              )
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: ScreenUtils.width,
                                height: ScreenUtils.height * 0.3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: bohibaTheme.cardColor),
                                child: controller.driverModel.value?.profile?.image == null ||
                                        (controller.driverModel.value!.profile?.image?.isEmpty ?? true)
                                    ? Text(
                                        controller.driverModel.value?.profile?.name?.shortCode ?? '',
                                        style: bohibaTheme.textTheme.displayLarge?.copyWith(
                                          color: bohibaTheme.textTheme.bodySmall!.color,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            "${ImagePath.profileImage}/${controller.driverModel.value?.profile?.image}",
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            width: ScreenUtils.width,
                                            height: ScreenUtils.height * 0.3,
                                            alignment: Alignment.center,
                                            child: Text(
                                              controller.driverModel.value?.profile?.name?.shortCode ?? '',
                                              style: bohibaTheme.textTheme.displayLarge?.copyWith(
                                                color: bohibaTheme.textTheme.bodySmall!.color,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: ScreenUtils.height15,
                                  left: ScreenUtils.height15,
                                  right: ScreenUtils.height15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            BohibaMarqueeText(
                                              width: ScreenUtils.width * 0.45,
                                              text: controller.driverModel.value?.profile?.name ?? '',
                                              overflowText: controller.driverModel.value?.profile?.name ?? '',
                                              style: bohibaTheme.textTheme.headlineMedium,
                                              marqueeTextStyle: bohibaTheme.textTheme.headlineMedium,
                                              preserFontSize: [bohibaTheme.textTheme.headlineMedium!.fontSize!],
                                            ),
                                            Text(
                                              controller.driverModel.value?.profile?.driverUuid ?? '',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                                                fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                                color: bohibaTheme.textTheme.titleMedium!.color,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Visibility(
                                          visible: controller.driverModel.value?.profile == null ? false : true,
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (controller.driverModel.value?.profile?.mobileNumber != null) {
                                                await LauncherService.makePhoneCall(
                                                  controller.driverModel.value!.profile!.mobileNumber!,
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 32.w,
                                              width: 32.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.25),
                                              ),
                                              child: Icon(
                                                Icons.phone_sharp,
                                                size: 16.w,
                                                color: bohibaTheme.colorScheme.onPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: ScreenUtils.height20),
                                      child: Text(
                                        'Basic Info',
                                        style: bohibaTheme.textTheme.headlineMedium,
                                      ),
                                    ),
                                    LinearBoxWidget(
                                      header: 'Role',
                                      title: controller.driverModel.value?.profile?.roleId?.roleName() ?? '',
                                    ),
                                    LinearBoxWidget(
                                      header: 'D.O.B',
                                      title: controller.driverModel.value?.profile?.dob,
                                    ),
                                    LinearBoxWidget(
                                      header: 'Status',
                                      title: controller.driverModel.value?.profile?.isActive?.toString(),
                                    ),
                                    LinearBoxWidget(
                                      header: 'Last Sync',
                                      title: controller.driverModel.value?.updatedAt,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: ScreenUtils.height30),
                                      child: Text(
                                        'License & Vehicle Details',
                                        style: bohibaTheme.textTheme.headlineMedium,
                                      ),
                                    ),
                                    LinearBoxWidget(
                                      header: 'Driving License',
                                      title: controller.driverModel.value?.licenseDetail?.licenseNumber,
                                    ),
                                    LinearBoxWidget(
                                      header: 'License Status',
                                      title: controller.driverModel.value?.licenseDetail?.status?.capitalizeFirst,
                                    ),
                                    LinearBoxWidget(
                                      header: 'COV',
                                      title: '',
                                    ),
                                    LinearBoxWidget(
                                      header: 'Issued',
                                      title: controller.driverModel.value?.licenseDetail?.validityFrom,
                                    ),
                                    LinearBoxWidget(
                                      header: 'Expiry',
                                      title: controller.driverModel.value?.licenseDetail?.validityTill,
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.driverModel.value?.rating == null ||
                                        (controller.driverModel.value?.rating?.isEmpty ?? false)
                                    ? false
                                    : true,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: ScreenUtils.height25,
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
                                              fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
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
                                child: controller.driverModel.value?.rating != null
                                    ? ListView.builder(
                                        itemCount: (controller.driverModel.value?.rating?.length ?? 0) >= 3
                                            ? 3
                                            : controller.driverModel.value?.rating?.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          if (controller.driverModel.value?.rating != null) {
                                            return SizedBox.shrink();
                                          }
                                          RatingModel? ratingModel = controller.driverModel.value?.rating![index];
                                          return Container(
                                            margin: EdgeInsets.only(bottom: ScreenUtils.height10),
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
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        ratingModel?.reviewerName ?? '',
                                                        style: bohibaTheme.textTheme.labelLarge,
                                                      ),
                                                      ReadMoreText(
                                                        ratingModel?.feedback ?? '',
                                                        trimLines: 2,
                                                        trimMode: TrimMode.Line,
                                                        trimCollapsedText: ' Read more',
                                                        trimExpandedText: ' Show less',
                                                        style: TextStyle(
                                                          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                                                          color: bohibaTheme.textTheme.titleMedium!.color,
                                                        ),
                                                        moreStyle: TextStyle(
                                                          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                                                          fontWeight: FontWeight.bold,
                                                          color: bohibaTheme.primaryColor,
                                                        ),
                                                        lessStyle: TextStyle(
                                                          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
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
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        ratingModel?.rating?.toString() ?? '0',
                                                        style: bohibaTheme.textTheme.labelLarge,
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
                            ],
                          ),
                        ),
                ),
              ),
              if (controller.didReviewed.value == true || controller.driverModel.value?.rating == null)
                SizedBox.shrink()
              else
                Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtils.width15,
                    right: ScreenUtils.width15,
                  ),
                  child: PrimaryButton(
                    onPressed: () {
                      navigate.pushNamed(AppRoute.ratingDriver, arguments: controller.driverModel).then((onValue) {
                        if (onValue != null) {
                          controller.isRated();
                        }
                      });
                    },
                    label: 'Rate Driver',
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
