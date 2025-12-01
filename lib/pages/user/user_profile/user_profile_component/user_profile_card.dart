import '/routes/app_route.dart';
import '/component/image_path.dart';
import '/controllers/dashboard_controller.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import '/pages/user/user_profile/switch_account_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: ScreenUtils.height10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: enableImageUpdate
                        ? () {
                            navigatorState.pushNamed(AppRoute.imageAuth, arguments: {
                              'canPop': true,
                              'route': 'pop',
                            }).then(
                              (onValue) async {
                                if (onValue != null) {
                                  await controller.getProfileModel();
                                }
                              },
                            );
                          }
                        : null,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(60.r),
                      child: userImage == null
                          ? Container(
                              width: 60.h,
                              height: 60.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: bohibaTheme.cardColor,
                              ),
                              child: Icon(Icons.file_upload_rounded),
                            )
                          : CachedNetworkImage(
                              imageUrl: "${ImagePath.profileImage}/$userImage",
                              width: 60.h,
                              height: 60.h,
                              fit: BoxFit.cover,
                              color: bohibaTheme.cardColor,
                              placeholder: (context, child) {
                                return SizedBox.shrink();
                              },
                              errorWidget: (context, child, obj) {
                                return SizedBox.shrink();
                              },
                            ),
                    ),
                  ),
                  // Gap(ScreenUtils.width15),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BohibaMarqueeText(
                        width: ScreenUtils.width * 0.65,
                        text: userName ?? '',
                        style: bohibaTheme.textTheme.headlineMedium,
                        overflowText: userName ?? '',
                        alignment: Alignment.centerRight,
                        marqueeTextStyle: bohibaTheme.textTheme.headlineMedium,
                        preserFontSize: [bohibaTheme.textTheme.headlineMedium!.fontSize!],
                      ),
                      Text(
                        userID ?? '',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                          color: bohibaTheme.textTheme.bodySmall!.color,
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: BottomModalShape(),
                              useSafeArea: true,
                              isScrollControlled: true,
                              builder: (context) {
                                return SwitchAccountDialog();
                              },
                            );
                          },
                          child: Container(
                            height: ScreenUtils.height30,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: bohibaTheme.primaryColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Text(
                                  'Switch Account',
                                  style: TextStyle(
                                    fontSize: bohibaTheme.textTheme.labelSmall!.fontSize,
                                    color: bohibaTheme.textTheme.displayLarge!.color,
                                    fontFamily: bohibaTheme.textTheme.displayLarge!.fontFamily,
                                  ),
                                ),
                                Gap(5.w),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: bohibaTheme.colorScheme.tertiary,
                                  size: 14.h,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Upload Button
              if (enableImageUpdate)
                GestureDetector(
                  onTap: () {
                    // Upload Image
                    navigatorState.pushNamed(AppRoute.imageAuth, arguments: {'canPop': true, 'route': 'pop'}).then((onValue) async {
                      if (onValue != null) {
                        await controller.getProfileModel();
                      }
                    });
                  },
                  child: Container(
                    height: ScreenUtils.height25,
                    width: ScreenUtils.width * 0.18,
                    margin: EdgeInsets.symmetric(vertical: 10.w),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: bohibaTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Upload',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.labelSmall!.fontSize,
                        color: bohibaTheme.textTheme.displayLarge!.color,
                        fontFamily: bohibaTheme.textTheme.displayLarge!.fontFamily,
                      ),
                    ),
                  ),
                )
              else
                SizedBox.shrink()
            ],
          ),
        ],
      ),
    );
  }
}
