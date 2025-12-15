import 'package:bohiba/component/image_path.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/model/rating_model.dart';

import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import '/controllers/dashboard_controller.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/services/role_permission_service.dart';
import '/extensions/bohiba_extension.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/linear_box_widget.dart';
import '/pages/widget/permission_widget.dart';
import '/pages/user/user_profile/user_profile_component/user_profile_card.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends GetView<DashboardController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: const TitleAppbar(title: "Profile"),
      body: Obx(
        () {
          return SmartRefresher(
            onRefresh: () async => await controller.onRefreshProfilePage(),
            controller: controller.refreshProfile,
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.height20,
                right: ScreenUtils.width15,
                left: ScreenUtils.width15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserProfileCard(
                    userImage: controller.profileModel.value?.image ?? '',
                    userName: controller.profileModel.value?.name,
                    userID: controller.profileModel.value?.uuid,
                  ),
                  Gap(ScreenUtils.height20),
                  Text(
                    "Basic Info",
                    style: bohibaTheme.textTheme.headlineMedium,
                  ),
                  LinearBoxWidget(
                    header: 'Role',
                    title: controller.profileModel.value?.roleId?.roleName(),
                  ),
                  RoleWidget(
                    truckOwnerWidget: LinearBoxWidget(
                      header: 'Hiring Status',
                      widget: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.statusOption.contains(controller.opted.value) ? controller.opted.value : null,
                          isDense: true,
                          hint: Text('Select status'),
                          borderRadius: BorderRadius.circular(8.0),
                          items: controller.statusOption
                              .map(
                                (status) => DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                          onChanged: (status) async {
                            if (status != null && controller.opted.value != status) {
                              controller.opted.value = status;
                              await controller.updateUserHiringStatus();
                            }
                          },
                        ),
                      ),
                    ),
                    driverWidget: LinearBoxWidget(
                      header: 'Job Status',
                      widget: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.statusOption.contains(controller.opted.value) ? controller.opted.value : null,
                          isDense: true,
                          borderRadius: BorderRadius.circular(8.0),
                          hint: Text('Select status'),
                          items: controller.statusOption
                              .map(
                                (status) => DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                          onChanged: (status) async {
                            if (status != null && controller.opted.value != status) {
                              controller.opted.value = status;
                              await controller.updateUserHiringStatus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  LinearBoxWidget(
                    header: 'D.O.B',
                    title: controller.profileModel.value?.dob,
                  ),
                  LinearBoxWidget(
                    onClick: () {
                      navigator.pushNamed(AppRoute.allTruck).then((onValue) async {
                        await controller.getProfileModel();
                      });
                    },
                    header: 'Total Truck',
                    title: controller.profileModel.value?.trucks.toString(),
                    showArrow: true,
                  ),
                  PermissionWidget(
                    permission: RolePermissionService.viewDriver,
                    child: LinearBoxWidget(
                      onClick: () {
                        navigator.pushNamed(AppRoute.allDriver);
                      },
                      header: 'Total Driver',
                      title: controller.profileModel.value?.driver?.toString() ?? '0',
                      showArrow: true,
                    ),
                  ),
                  Gap(ScreenUtils.height20),
                  Text(
                    "Contact Info",
                    style: bohibaTheme.textTheme.headlineMedium,
                  ),
                  LinearBoxWidget(
                    header: 'Mobile Number',
                    title: controller.profileModel.value?.mobileNumber,
                  ),
                  LinearBoxWidget(
                    header: 'E-Mail',
                    title: controller.profileModel.value?.email,
                  ),
                  Gap(ScreenUtils.height20),
                  RoleWidget(
                    driverWidget: Column(
                      children: [
                        Align(
                          alignment: AlignmentGeometry.centerLeft,
                          child: Text(
                            "Ratings",
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),
                        Obx(
                          () {
                            final ratings = controller.profileModel.value?.ratings;

                            if (ratings != null && ratings.isNotEmpty) {
                              return ListView.builder(
                                itemCount: controller.profileModel.value?.ratings?.length ?? 0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(top: ScreenUtils.height10),
                                itemBuilder: (context, index) {
                                  RatingModel rating = ratings[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: ScreenUtils.height10),
                                    // padding: EdgeInsets.symmetric(
                                    //   horizontal: ScreenUtils.width15,
                                    // ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 32.h,
                                          width: 32.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: bohibaTheme.colorScheme.surface,
                                          ),
                                          child: rating.reviewerImage == null || (rating.reviewerImage?.isEmpty ?? true)
                                              ? Text(
                                                  rating.reviewerImage?.shortCode ?? '',
                                                  style: TextStyle(
                                                    fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                                                    fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                                                    color: bohibaTheme.textTheme.bodySmall!.color,
                                                  ),
                                                )
                                              : Container(
                                                  height: 32.h,
                                                  width: 32.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: bohibaTheme.dividerColor,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadiusGeometry.circular(35.r),
                                                    child: CachedNetworkImage(
                                                      imageUrl: '${ImagePath.profileImage}/${rating.reviewerImage}',
                                                      fit: BoxFit.cover,
                                                      height: 32.h,
                                                      width: 32.h,
                                                      placeholder: (context, url) => Container(
                                                        color: bohibaTheme.cardColor,
                                                      ),
                                                      errorWidget: (context, url, error) => Icon(
                                                        Icons.broken_image,
                                                        size: 20,
                                                        color: bohibaTheme.cardColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        Gap(8.w),
                                        SizedBox(
                                          width: ScreenUtils.width * 0.55.w,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                rating.reviewerName ?? '',
                                                style: bohibaTheme.textTheme.labelLarge,
                                              ),
                                              ReadMoreText(
                                                rating.feedback ?? '',
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
                                                rating.rating?.toStringAsFixed(1) ?? '',
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
                              );
                            } else {
                              return Container(
                                width: ScreenUtils.width * 0.75,
                                padding: EdgeInsets.symmetric(vertical: ScreenUtils.height20),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(
                                      'No Rating',
                                      textAlign: TextAlign.center,
                                      style: bohibaTheme.textTheme.headlineLarge,
                                    ),
                                    Text(
                                      'You haven\'t received any rating from truck owners. Your truck owner can help you to get first rating.',
                                      textAlign: TextAlign.center,
                                      style: bohibaTheme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
