import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserProfileCard extends StatelessWidget {
  final VoidCallback editProfile;
  final String userImage;
  final String? userName;
  final String? userID;
  final String? dob;

  const UserProfileCard({
    super.key,
    required this.editProfile,
    this.userImage = '',
    this.dob,
    this.userName = "User Name",
    this.userID = "AB000TY0",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      padding: EdgeInsets.only(
        left: ScreenUtils.width15,
        right: ScreenUtils.width15,
        bottom: ScreenUtils.height10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(userImage),
                ),
              ),
              Gap(ScreenUtils.width15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BohibaMarqueeText(
                    width: ScreenUtils.width * 0.45,
                    text: userName ?? 'NA',
                    style: bohibaTheme.textTheme.headlineSmall,
                    overflowText: userName ?? 'NA',
                    marqueeTextStyle: bohibaTheme.textTheme.headlineSmall,
                  ),
                  Text(
                    userID ?? 'NA',
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                      color: bohibaTheme.textTheme.bodySmall!.color,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: editProfile,
                child: Container(
                  height: ScreenUtils.height30,
                  width: ScreenUtils.width * 0.18,
                  decoration: BoxDecoration(
                    color: BohibaColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.0.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: BohibaColors.white,
                        fontSize: bohibaTheme.textTheme.labelSmall!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.labelMedium!.fontWeight),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
