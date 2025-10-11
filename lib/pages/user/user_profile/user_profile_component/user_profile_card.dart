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
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: ScreenUtils.height10),
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
                    width: ScreenUtils.width * 0.3,
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
              /*GestureDetector(
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
                          color: bohibaTheme.textTheme.displayLarge!.color,
                          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.labelLarge!.fontWeight,
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
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
