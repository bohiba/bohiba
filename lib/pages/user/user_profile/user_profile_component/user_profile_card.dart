import '/component/image_path.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/pages/user/user_profile/switch_account_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserProfileCard extends StatelessWidget {
  final String userImage;
  final String? userName;
  final String? userID;
  final String? dob;

  const UserProfileCard({
    super.key,
    this.userImage = '',
    this.dob,
    this.userName = "",
    this.userID = "",
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
                    onTap: () {
                      navigatorState.pushNamed(AppRoute.imageAuth);
                    },
                    child: CircleAvatar(
                      radius: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(30.r),
                        child: CachedNetworkImage(
                          imageUrl: "${ImagePath.profileImage}/$userImage",
                          width: 60.h,
                          height: 60.h,
                          fit: BoxFit.cover,
                          placeholder: (context, child) {
                            return Image.network(
                              GlobalService.getAvatarUrl(userName ?? ''),
                            );
                          },
                          errorWidget: (context, child, obj) {
                            return Image.network(
                              GlobalService.getAvatarUrl(userName ?? ''),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Gap(ScreenUtils.width15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BohibaMarqueeText(
                        width: ScreenUtils.width * 0.37,
                        text: userName ?? '',
                        style: bohibaTheme.textTheme.headlineSmall,
                        overflowText: userName ?? '',
                        marqueeTextStyle: bohibaTheme.textTheme.headlineSmall,
                      ),
                      Text(
                        userID ?? '',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                          color: bohibaTheme.textTheme.bodySmall!.color,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
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
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                                color:
                                    bohibaTheme.textTheme.displayLarge!.color,
                                fontSize:
                                    bohibaTheme.textTheme.labelMedium!.fontSize,
                                fontWeight: bohibaTheme
                                    .textTheme.labelLarge!.fontWeight,
                              ),
                            ),
                            Gap(5.w),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: bohibaTheme.colorScheme.tertiary,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Upload Button
              GestureDetector(
                onTap: () {
                  // Upload Image
                  navigatorState.pushNamed(AppRoute.imageAuth,
                      arguments: {'canPop': true, 'route': 'pop'});
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
                      fontFamily:
                          bohibaTheme.textTheme.displayLarge!.fontFamily,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
