import 'package:gap/gap.dart';
import '/pages/widget/icon_text_tile.dart';
import '/services/global_service.dart';
import '/controllers/user_profile_config_controller.dart';
import 'package:get/get.dart';
import '/component/bohiba_buttons/primary_button.dart';
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
              Gap(ScreenUtils.height10),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.userRoleList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return IconTextTile(
                      onTap: () {
                        controller.roleObj = controller.selectAddress(index);
                        GlobalService.printHandler('${controller.roleObj}');
                        setState(() {});
                      },
                      text: controller.userRoleList[index]['label'].toString(),
                      subtitle:
                          controller.userRoleList[index]['subTitle'].toString(),
                      widget: RadioGroup(
                        groupValue: controller.selectedIndex.value,
                        onChanged: (v) {
                          if (v == null) {
                          } else {
                            controller.roleObj =
                                controller.selectAddress(index);
                            GlobalService.printHandler('${controller.roleObj}');
                            setState(() {});
                          }
                        },
                        child: Radio(value: index),
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
                      : () async {
                          await controller.setRole();
                        },
                  label: "Set Role",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
