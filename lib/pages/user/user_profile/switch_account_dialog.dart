import '/model/user_list_model.dart';
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
    return SafeArea(
      child: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Accounts',
                style: bohibaTheme.textTheme.displayMedium,
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.arrLoggedInUser.length,
                  padding: EdgeInsets.only(top: ScreenUtils.height10),
                  itemBuilder: (context, index) {
                    UserListModel loggedUser =
                        controller.arrLoggedInUser[index];
                    return Container(
                      // height: ScreenUtils.height47,
                      margin: EdgeInsets.only(bottom: ScreenUtils.height10),
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtils.width15,
                        vertical: ScreenUtils.height10,
                      ),
                      decoration: TileDecorative(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20.w,
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
                                  loggedUser.name ?? '',
                                  style: bohibaTheme.textTheme.labelLarge,
                                ),
                                Text(
                                  loggedUser.uuid ?? '',
                                  style: bohibaTheme.textTheme.titleSmall,
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          RadioGroup(
                            onChanged: (v) {},
                            groupValue: true,
                            child: Radio(
                              value: loggedUser.isLoggedIn ?? false,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add_rounded),
              label: Text('Add Account'),
            ),
          ],
        ),
      ),
    );
  }
}
