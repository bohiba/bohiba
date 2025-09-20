import 'package:bohiba/controllers/security_controller.dart';
import 'package:get/get.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/pages/widget/icon_text_tile.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SecurityPage extends GetView<SecurityController> {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Security'),
      body: SafeArea(
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
                widget: Switch(value: true, onChanged: (c) {}),
              ),
              Gap(ScreenUtils.height30),
              Text('Password Management',
                  style: bohibaTheme.textTheme.headlineMedium),
              LinearBoxWidget(
                header: 'Change Password',
                showArrow: true,
              ),
              LinearBoxWidget(
                header: 'Forgot Password',
                showArrow: true,
              ),
              Gap(ScreenUtils.height30),
              Text('Active Session',
                  style: bohibaTheme.textTheme.headlineMedium),
              IconTextTile(
                icon: Icons.smartphone_outlined,
                text: 'iPhone 13 Pro',
                subtitle: 'Last Active: Fri 19 Sep 11:01 pm',
                widget: Container(),
              ),
              IconTextTile(
                icon: Icons.laptop_outlined,
                text: 'Macbook Pro',
                subtitle: 'Last Active: Fri 19 Sep 11:01 pm',
                widget: Container(),
              ),
              Gap(ScreenUtils.height30),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtils.height10,
                  horizontal: ScreenUtils.width15,
                ),
                decoration: BoxDecoration(
                  color: bohibaTheme.cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: ScreenUtils.height5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Log out from all other devices',
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.bodyMedium!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleMedium!.color,
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
                      onTap: () async => await controller.logOut(),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: ScreenUtils.height5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Log out from this device',
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodyMedium!.fontSize,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.titleMedium!.color,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Icon(
                                EvaIcons.logOutOutline,
                                size: ScreenUtils.height15.h,
                                color: bohibaTheme.colorScheme.error,
                              ),
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
  }
}
