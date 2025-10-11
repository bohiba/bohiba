import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import '/pages/widget/permission_widget.dart';
import '/services/role_permission_service.dart';

import '/component/screen_utils.dart';
import '/controllers/dashboard_controller.dart';
import '/services/global_service.dart';
import '/extensions/bohiba_extension.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/linear_box_widget.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

// import '/pages/user/user_profile/edit_user_profile_screen.dart';
import '/pages/user/user_profile/user_profile_component/user_profile_card.dart';
import 'package:flutter/material.dart';
import '/component/bohiba_appbar/title_appbar.dart';

class UserProfilePage extends GetView<DashboardController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: const TitleAppbar(title: "Profile"),
      body: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtils.height20,
          right: ScreenUtils.width15,
          left: ScreenUtils.width15,
        ),
        child: Obx(() {
          return SmartRefresher(
            onRefresh: () async => await controller.onRefreshProfilePage(),
            controller: controller.refreshProfile,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserProfileCard(
                  userImage: GlobalService.getAvatarUrl(
                      controller.profileModel.value!.name!),
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
                LinearBoxWidget(
                  header: 'D.O.B',
                  title: controller.profileModel.value?.dob,
                ),
                RoleWidget(
                  driverWidget: LinearBoxWidget(
                    header: 'Job Status',
                    title: controller.profileModel.value?.jobStatus
                        ?.toDisplayLabel(),
                  ),
                ),
                LinearBoxWidget(
                  onClick: () {
                    navigator
                        .pushNamed(AppRoute.allTruck)
                        .then((onValue) async {
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
                    title: controller.profileModel.value?.drivers.toString(),
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
                          final ratings =
                              controller.profileModel.value?.ratings ?? [];
                          if (ratings.isEmpty) {
                            return Container(
                              width: ScreenUtils.width * 0.75,
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtils.height20),
                              constraints: BoxConstraints(
                                  minHeight: ScreenUtils.height * 0.25),
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
                          } else {
                            return ListView.builder(
                              itemCount: controller
                                      .profileModel.value?.ratings?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding:
                                  EdgeInsets.only(top: ScreenUtils.height10),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: ScreenUtils.height10),
                                  // padding: EdgeInsets.symmetric(
                                  //   horizontal: ScreenUtils.width15,
                                  // ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 15.w,
                                        backgroundColor:
                                            bohibaTheme.dividerColor,
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
                                              'User Name',
                                              style: bohibaTheme
                                                  .textTheme.labelLarge,
                                            ),
                                            ReadMoreText(
                                              'Desc',
                                              trimLines: 2,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: ' Read more',
                                              trimExpandedText: ' Show less',
                                              style: TextStyle(
                                                fontSize: bohibaTheme.textTheme
                                                    .labelMedium!.fontSize,
                                                color: bohibaTheme.textTheme
                                                    .titleMedium!.color,
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
                                              '0',
                                              style: bohibaTheme
                                                  .textTheme.labelLarge,
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
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
