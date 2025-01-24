import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserProfileCard extends StatelessWidget {
  final VoidCallback editProfile;
  final String userImage;
  final String userName;
  final String userID;
  final String dob;
  final int countVehicle;

  const UserProfileCard(
      {super.key,
      required this.editProfile,
      this.userImage =
          "https://th.bing.com/th/id/R.4b1ebbdf9a6a42f23de2678c80eb02df?rik=SEPvooeqfgw0kA&riu=http%3a%2f%2fimages.unsplash.com%2fphoto-1535713875002-d1d0cf377fde%3fcrop%3dentropy%26cs%3dtinysrgb%26fit%3dmax%26fm%3djpg%26ixid%3dMnwxMjA3fDB8MXxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8fDB8fHx8MTYyNTY2NzI4OQ%26ixlib%3drb-1.2.1%26q%3d80%26w%3d1080&ehk=Gww3MHYoEwaudln4mR6ssDjrAMbAvyoXYMsyKg5p0Ac%3d&risl=&pid=ImgRaw&r=0",
      this.dob = "01.01.1999",
      this.userName = "User Name",
      this.userID = "AB000TY0",
      this.countVehicle = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      padding: EdgeInsets.only(
        left: BohibaResponsiveScreen.width15,
        right: BohibaResponsiveScreen.width15,
        bottom: BohibaResponsiveScreen.height10,
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
              Gap(BohibaResponsiveScreen.width15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BohibaMarqueeText(
                    width: BohibaResponsiveScreen.width * 0.45,
                    text: userName,
                    style: bohibaTheme.textTheme.headlineSmall,
                    overflowText: userName,
                    marqueeTextStyle: bohibaTheme.textTheme.headlineSmall,
                  ),
                  Text(
                    userID,
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
                  height: BohibaResponsiveScreen.height25,
                  width: BohibaResponsiveScreen.width * 0.18,
                  decoration: BoxDecoration(
                    color: bohibaColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: bohibaColors.white,
                        fontSize: bohibaTheme.textTheme.labelSmall!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.labelMedium!.fontWeight),
                  ),
                ),
              ),
            ],
          ),
          Gap(BohibaResponsiveScreen.height25),
          Text(
            "Date of Birth",
            style: bohibaTheme.textTheme.headlineLarge,
          ),
          Text(
            dob,
            style: bohibaTheme.textTheme.bodyLarge,
          ),
          Gap(BohibaResponsiveScreen.height10),
          Text(
            "Total no of vehicle owned",
            style: bohibaTheme.textTheme.headlineLarge,
          ),
          Text(
            countVehicle.toString(),
            style: bohibaTheme.textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}
