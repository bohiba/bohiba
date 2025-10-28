import '/dist/app_enums.dart';
import '/services/global_service.dart';

import '/pages/widget/icon_text_tile.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';
import '/routes/app_route.dart';

import '/controllers/security_controller.dart';

import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/component/bohiba_appbar/appbar_icon.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/password_inputfield.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecurityPage extends GetView<SecurityController> {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(title: 'Security'),
      body: Obx(() {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.height20,
                left: ScreenUtils.width15,
                right: ScreenUtils.width15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('App Lock', style: bohibaTheme.textTheme.headlineMedium),
                  IconTextTile(
                    icon: Icons.fingerprint_outlined,
                    text: 'Enable Biometric Unlock',
                    subtitle: 'Use fingerprint or biometric unlock',
                    widget: Switch(
                      value: controller.isBioMetricEnabled.value,
                      onChanged: (c) {
                        controller.setBioMetric(enable: c).then((onValue) {
                          controller.getBiometricInfo();
                        });
                      },
                    ),
                  ),
                  Gap(ScreenUtils.height30),
                  Text('Password Management',
                      style: bohibaTheme.textTheme.headlineMedium),
                  LinearBoxWidget(
                    header: 'Change Password',
                    showArrow: true,
                    onClick: () {
                      Get.bottomSheet(
                        isScrollControlled: false,
                        useRootNavigator: true,
                        shape: BottomModalShape(),
                        backgroundColor: bohibaTheme.scaffoldBackgroundColor,
                        Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtils.height15,
                            right: ScreenUtils.height15,
                            top: ScreenUtils.height20,
                            bottom: MediaQuery.paddingOf(context).bottom,
                          ),
                          child: Form(
                            key: controller.formState,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Current Password',
                                    style: bohibaTheme.textTheme.displaySmall,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Please enter your current password to access this feature",
                                    style: bohibaTheme.textTheme.titleMedium,
                                  ),
                                ),
                                PasswordInputField(
                                  hintText: 'Password',
                                  nextActionType: TextInputAction.done,
                                  controller: controller.pwdController,
                                ),
                                PrimaryButton(
                                  padding: EdgeInsets.only(top: 15.h),
                                  label: 'Verify',
                                  onPressed: () {
                                    if (controller.pwdController.text.isEmpty ||
                                        controller.pwdController.text.length <=
                                            6) {
                                      GlobalService.showSnackBar(
                                        status: AlertStatus.info,
                                        title: 'Security',
                                        desc: 'Please enter valid password',
                                      );
                                      return;
                                    }
                                    navigateState.popAndPushNamed(
                                      AppRoute.changePwd,
                                      arguments: controller.pwdController.text,
                                    );

                                    controller.pwdController.clear();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  LinearBoxWidget(
                    header: 'Forgot Password',
                    showArrow: true,
                    onClick: () {
                      navigateState.pushNamed(AppRoute.forgotPwd);
                    },
                  ),
                  Gap(ScreenUtils.height30),
                  Text('App Information',
                      style: bohibaTheme.textTheme.headlineMedium),
                  LinearBoxWidget(
                    header: 'Version',
                    title: controller.appInfo['version'],
                  ),
                  LinearBoxWidget(
                    header: 'Installed From',
                    title: controller.appInfo['installerStore'].toString(),
                  ),
                  LinearBoxWidget(
                    header: 'Last Updated',
                    title: controller.appInfo['updateTime'].toString(),
                  ),
                  Gap(ScreenUtils.height30),
                  Text('Active Session',
                      style: bohibaTheme.textTheme.headlineMedium),
                  IconTextTile(
                    icon: Icons.smartphone_outlined,
                    text: 'iPhone 13 Pro',
                    subtitle: 'Last Active: Fri 19 Sep 11:01 pm',
                    widget: AppBarIconBox(
                      icon: Icon(
                        EvaIcons.logOutOutline,
                        size: ScreenUtils.height15.h,
                        color: bohibaTheme.colorScheme.error,
                      ),
                    ),
                  ),
                  IconTextTile(
                    icon: Icons.laptop_outlined,
                    text: 'Macbook Pro',
                    subtitle: 'Last Active: Fri 19 Sep 11:01 pm',
                    widget: AppBarIconBox(
                      icon: Icon(
                        EvaIcons.logOutOutline,
                        size: ScreenUtils.height15.h,
                        color: bohibaTheme.colorScheme.error,
                      ),
                    ),
                  ),
                  Gap(ScreenUtils.height30),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenUtils.height10,
                      horizontal: ScreenUtils.width15,
                    ),
                    margin: EdgeInsets.only(
                      top: ScreenUtils.height5,
                      bottom: ScreenUtils.width15,
                    ),
                    decoration: BoxDecoration(
                      color: bohibaTheme.cardColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtils.height5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Log out from all other devices',
                                style: TextStyle(
                                  fontSize: bohibaTheme
                                      .textTheme.bodyMedium!.fontSize,
                                  fontWeight: bohibaTheme
                                      .textTheme.bodySmall!.fontWeight,
                                  color:
                                      bohibaTheme.textTheme.titleMedium!.color,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: ScreenUtils.height15.h,
                                  color: bohibaTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        InkWell(
                          onTap: () async {
                            GlobalService.showAlertDialog(
                              status: AlertStatus.warning,
                              title: 'Logout',
                              description:
                                  'Are you sure? You want to log out from this account. Press `Log out` to proceed',
                              onSave: () {
                                navigateState.pop();
                              },
                              discardBtnTxt: 'LOG OUT',
                              saveBtnTxt: 'NO',
                              onDiscard: () async {
                                navigateState.pop();
                                int loggedOut = await controller.logOut();
                                if (loggedOut > 0) {
                                  navigateState.pushNamedAndRemoveUntil(
                                      AppRoute.signIn,
                                      (Route<dynamic> route) => false);
                                }
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtils.height5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Log out from this device',
                                  style: TextStyle(
                                    fontSize: bohibaTheme
                                        .textTheme.bodyMedium!.fontSize,
                                    fontWeight: bohibaTheme
                                        .textTheme.bodySmall!.fontWeight,
                                    color: bohibaTheme.colorScheme.error,
                                  ),
                                ),
                                Icon(
                                  EvaIcons.logOutOutline,
                                  size: ScreenUtils.height15.h,
                                  color: bohibaTheme.colorScheme.error,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
