import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/controllers/setting_controller.dart';
import '/pages/widget/linear_box_widget.dart';

import '/services/user_role_type.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Setting'),
      body: Obx(() {
        return Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Notifications",
                  style: bohibaTheme.textTheme.headlineMedium),
              LinearBoxWidget(
                header: 'Push notifications',
                widget: Switch(
                  value: controller.notifications.value,
                  onChanged: (v) {
                    controller.notifications.value = v;
                  },
                ),
              ),
              LinearBoxWidget(
                header: 'Email updates',
                widget: Switch(
                  value: controller.updates.value,
                  onChanged: (v) {
                    controller.updates.value = v;
                  },
                ),
              ),
              Gap(ScreenUtils.height30),
              Text("Appearance", style: bohibaTheme.textTheme.headlineMedium),
              LinearBoxWidget(
                header: 'Theme',
                widget: DropdownButtonHideUnderline(
                  child: DropdownButton<ThemeMode>(
                    value: controller.themeMode.value,
                    isDense: true,
                    borderRadius: BorderRadius.circular(8.0),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text("Light"),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text("Dark"),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text("System"),
                      ),
                    ],
                    onChanged: (ThemeMode? newMode) async {
                      if (newMode != null) {
                        await controller.themeController.changeTheme(newMode);
                      }
                    },
                  ),
                ),
              ),
              Gap(ScreenUtils.height30),
              Text("Storage", style: bohibaTheme.textTheme.headlineMedium),
              LinearBoxWidget(
                onClick: () {},
                header: 'Clear Cache',
                widget: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtils.height5,
                      horizontal: ScreenUtils.width10),
                  decoration: BoxDecoration(
                    color: bohibaTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                      color: bohibaTheme
                          .listTileTheme.leadingAndTrailingTextStyle!.color,
                    ),
                  ),
                ),
              ),
              Gap(ScreenUtils.height30),
              Text(
                "Account",
                style: bohibaTheme.textTheme.headlineMedium,
              ),
              LinearBoxWidget(
                onClick: null,
                header: 'Switch Profile',
                widget: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.roleId.value,
                    isDense: true,
                    borderRadius: BorderRadius.circular(8.0),
                    items: const [
                      DropdownMenuItem(
                        value: UserRoles.driver,
                        child: Text("Driver"),
                      ),
                      DropdownMenuItem(
                        value: UserRoles.truckOwner,
                        child: Text("Truck Owner"),
                      ),
                    ],
                    onChanged: (userRole) async {
                      if (userRole != null &&
                          controller.roleId.value != userRole) {
                        controller.roleId.value = userRole;
                        await controller.switchProfile();
                      }
                    },
                  ),
                ),
              ),
              LinearBoxWidget(
                onClick: () {},
                header: 'Edit profile',
                showArrow: true,
              ),
              LinearBoxWidget(
                onClick: () {},
                header: 'Change phone/ email',
                showArrow: true,
              ),
            ],
          ),
        );
      }),
    );
  }
}
