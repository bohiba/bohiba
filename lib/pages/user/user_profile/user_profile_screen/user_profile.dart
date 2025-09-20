import '/component/screen_utils.dart';
import '/controllers/dashboard_controller.dart';
import '../../../../services/global_service.dart';
import '/extensions/bohiba_extension.dart';
import '/pages/user/user_profile/edit_user_profile_screen.dart';
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
                    editProfile: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditUserProfilePage(),
                        ),
                      );
                    },
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
                  LinearBoxWidget(
                    header: 'Job Status',
                    title: controller.profileModel.value?.jobStatus
                        ?.toDisplayLabel(),
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
                  LinearBoxWidget(
                    onClick: () {
                      navigator.pushNamed(AppRoute.allDriver);
                    },
                    header: 'Total Driver',
                    title: controller.profileModel.value?.drivers.toString(),
                    showArrow: true,
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
                  Text(
                    "Document Info",
                    style: bohibaTheme.textTheme.headlineMedium,
                  ),
                  LinearBoxWidget(
                    header: 'Aadhar Number',
                    title: controller
                            .profileModel.value?.verification?.aadhaarNumber ??
                        'NA',
                  ),
                  LinearBoxWidget(
                    header: 'Pan Number',
                    title: controller
                            .profileModel.value?.verification?.panNumber ??
                        'NA',
                  ),
                  LinearBoxWidget(
                    header: 'DL Number',
                    title:
                        controller.profileModel.value?.verification?.dlNumber ??
                            'NA',
                  ),
                  LinearBoxWidget(
                    header: 'Verification Status',
                    title: controller.profileModel.value?.verification
                            ?.verificationStatus!
                            .toUpperCase() ??
                        'NA',
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
