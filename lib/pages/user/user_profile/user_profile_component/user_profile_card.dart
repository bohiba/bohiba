import '/routes/app_route.dart';
import '/component/image_path.dart';
import '/controllers/dashboard_controller.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/component/bohiba_network_image.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UserProfileCard extends GetView<DashboardController> {
  final String? userImage;
  final String? userName;
  final String? userID;
  final String? dob;
  final bool enableImageUpdate;

  const UserProfileCard({
    super.key,
    this.userImage = '',
    this.dob,
    this.userName = "",
    this.userID = "",
    this.enableImageUpdate = true,
  });

  @override
  Widget build(BuildContext context) {
    final navigatorState = Navigator.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: ScreenUtils.height10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BohibaNetworkImage.circle(
            imageUrl: '${ImagePath.profileImage}/$userImage',
            size: 60.h,
            fallbackText: userName,
          ),

          // Gap(ScreenUtils.width15),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BohibaMarqueeText(
                width: ScreenUtils.width * 0.65,
                text: userName ?? '',
                style: bohibaTheme.textTheme.headlineMedium,
                overflowText: userName ?? '',
                alignment: Alignment.centerRight,
                marqueeTextStyle: bohibaTheme.textTheme.headlineMedium,
                preserFontSize: [
                  bohibaTheme.textTheme.headlineMedium!.fontSize!
                ],
              ),
              Text(
                userID ?? '',
                style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                    color: bohibaTheme.textTheme.bodySmall!.color),
              ),
              // Upload Button
              if (enableImageUpdate)
                GestureDetector(
                  onTap: () {
                    // Upload Image
                    navigatorState.pushNamed(AppRoute.imageAuth, arguments: {
                      'canPop': true,
                      'route': 'pop',
                      'canSkip': false
                    }).then((onValue) async {
                      if (onValue != null) {
                        await controller.getProfileModel();
                      }
                    });
                  },
                  child: Container(
                    height: ScreenUtils.height30,
                    width: 85.h,
                    margin: EdgeInsets.symmetric(vertical: 10.w),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                        color: bohibaTheme.primaryColor,
                        borderRadius: BorderRadius.circular(20.r)),
                    alignment: Alignment.center,
                    child: Text(
                      'Upload',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                          color: bohibaTheme.textTheme.displayLarge!.color,
                          fontFamily:
                              bohibaTheme.textTheme.displayLarge!.fontFamily),
                    ),
                  ),
                )
              else
                SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
