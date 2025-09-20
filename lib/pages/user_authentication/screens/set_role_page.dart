import '/services/global_service.dart';

import '/controllers/user_profile_config_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/routes/app_route.dart';
import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import '/theme/bohiba_theme.dart';

class SetRolePage extends StatefulWidget {
  const SetRolePage({super.key});

  @override
  State<SetRolePage> createState() => _SetRolePageState();
}

class _SetRolePageState extends State<SetRolePage> {
  final controller = Get.find<UserProfileConfigController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(
          height: ScreenUtils.height,
          width: ScreenUtils.width,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.width20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                'Select User Role',
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              Text(
                'Choose your user type to rate and connect better',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                  fontWeight: bohibaTheme.textTheme.titleSmall!.fontWeight,
                  color: bohibaTheme.textTheme.titleSmall!.color,
                ),
              ),
              SizedBox(
                height: ScreenUtils.height * 0.165,
                width: ScreenUtils.width,
                // color: Colors.amberAccent,
                child: ListView.builder(
                  itemCount: controller.userRoleList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.0.h),
                      child: RadioListTile.adaptive(
                        title: Text(
                            controller.userRoleList[index]['label'].toString()),
                        value: index,
                        groupValue: controller.selectedIndex.value,
                        toggleable: true,
                        onChanged: (v) {
                          if (v == null) {
                          } else {
                            controller.roleObj =
                                controller.selectAddress(index);
                            GlobalService.printHandler('${controller.roleObj}');
                            setState(() {});
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtils.height30),
                child: PrimaryButton(
                  onPressed: controller.roleObj.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pushNamed(
                            AppRoute.userAuthScreen,
                            arguments: {
                              "role_id": controller.roleObj['role_id'],
                            },
                          );
                        },
                  label: "Next",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
