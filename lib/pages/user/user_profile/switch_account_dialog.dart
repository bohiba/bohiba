import '/component/bohiba_buttons/secoundary_button.dart';
import '/component/bohiba_inputfield/password_inputfield.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/services/global_service.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '../../../model/logged_in_user_model.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/controllers/dashboard_controller.dart';

class SwitchAccountDialog extends StatefulWidget {
  const SwitchAccountDialog({super.key});

  @override
  State<SwitchAccountDialog> createState() => _SwitchAccountDialogState();
}

class _SwitchAccountDialogState extends State<SwitchAccountDialog> {
  final controller = Get.find<DashboardController>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await controller.getLoggedUserAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    return SafeArea(
      child: Container(
        height: ScreenUtils.height * 0.83,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.r),
            topLeft: Radius.circular(12.r),
          ),
        ),
        padding: EdgeInsets.only(
          left: ScreenUtils.height15,
          right: ScreenUtils.height15,
          top: ScreenUtils.height20,
        ),
        alignment: Alignment.center,
        child: Obx(
          () {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Accounts',
                    style: bohibaTheme.textTheme.displaySmall,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Choose an account to switch — stay connected and keep your work flowing smoothly.",
                    style: bohibaTheme.textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.arrLoggedInUser.length,
                    padding: EdgeInsets.only(top: ScreenUtils.height10),
                    itemBuilder: (context, index) {
                      LoggedInAccountModel loggedUser =
                          controller.arrLoggedInUser[index];
                      isLoggedIn =
                          (controller.profileModel.value?.uuid ?? '') ==
                              (loggedUser.uuid ?? '');
                      return GestureDetector(
                        onTap: () {
                          controller.selectUser.value = loggedUser;
                        },
                        child: Container(
                          // height: ScreenUtils.height47,
                          margin: EdgeInsets.only(bottom: ScreenUtils.height10),
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtils.width15,
                            vertical: ScreenUtils.height10,
                          ),
                          decoration: TileDecorative(
                            color: isLoggedIn
                                ? bohibaTheme.colorScheme.onPrimary
                                : null,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20.w,
                                backgroundColor: bohibaTheme.dividerColor,
                              ),
                              Gap(8.w),
                              SizedBox(
                                width: ScreenUtils.width * 0.35.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      loggedUser.name ?? '',
                                      style: bohibaTheme.textTheme.labelLarge,
                                    ),
                                    Text(
                                      loggedUser.uuid ?? '',
                                      style: TextStyle(
                                        fontSize: bohibaTheme
                                            .textTheme.titleSmall!.fontSize,
                                        color: bohibaTheme
                                            .textTheme.titleLarge!.color,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Obx(
                                () {
                                  return RadioGroup<LoggedInAccountModel>(
                                    onChanged: (v) {
                                      controller.selectUser.value = v!;
                                    },
                                    groupValue: controller.selectUser.value,
                                    child: Radio(
                                      value: loggedUser,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Gap(10.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SecoundaryButton(
                        width: ScreenUtils.width / 2.3,
                        label: 'Add New',
                        onPressed: () {
                          Get.bottomSheet(
                            isScrollControlled: false,
                            useRootNavigator: true,
                            shape: BottomModalShape(),
                            backgroundColor:
                                bohibaTheme.scaffoldBackgroundColor,
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtils.height15,
                                right: ScreenUtils.height15,
                                top: ScreenUtils.height20,
                                bottom: MediaQuery.paddingOf(context).bottom,
                              ),
                              child: Form(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Login to new account',
                                        style:
                                            bohibaTheme.textTheme.displaySmall,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Choose an account to switch — stay connected and keep your work flowing smoothly.",
                                        style:
                                            bohibaTheme.textTheme.titleMedium,
                                      ),
                                    ),
                                    TextInputField(
                                      width: ScreenUtils.width,
                                      hintText: 'User ID',
                                      maxLength: 6,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      nextActionType: TextInputAction.next,
                                      prefixIcon: Icon(
                                        Icons.person_rounded,
                                        color: bohibaTheme.inputDecorationTheme
                                            .prefixIconColor,
                                      ),
                                    ),
                                    PasswordInputField(
                                      hintText: 'Password',
                                      nextActionType: TextInputAction.done,
                                    ),
                                    PrimaryButton(
                                      padding: EdgeInsets.only(top: 15.h),
                                      label: 'Log in',
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      PrimaryButton(
                        width: ScreenUtils.width / 2.3,
                        label: 'Switch Account',
                        onPressed: controller.selectUser.value.uuid == null ||
                                (controller.selectUser.value.uuid ==
                                    controller.profileModel.value?.uuid)
                            ? null
                            : () async {
                                GlobalService.printHandler(
                                    '${controller.selectUser.toJson()}');
                              },
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.selectUser.value = LoggedInAccountModel();
    super.dispose();
  }
}
