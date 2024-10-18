import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges
;import 'package:remixicon/remixicon.dart';

class UserProfileCard extends StatelessWidget {
  final VoidCallback editProfile;
  final String userImage;
  final String userName;
  final String userID;
  final String dob;
  final int countVehicle;

  const UserProfileCard({
    Key? key,
    required this.editProfile,
    this.userImage = "https://th.bing.com/th/id/R.4b1ebbdf9a6a42f23de2678c80eb02df?rik=SEPvooeqfgw0kA&riu=http%3a%2f%2fimages.unsplash.com%2fphoto-1535713875002-d1d0cf377fde%3fcrop%3dentropy%26cs%3dtinysrgb%26fit%3dmax%26fm%3djpg%26ixid%3dMnwxMjA3fDB8MXxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8fDB8fHx8MTYyNTY2NzI4OQ%26ixlib%3drb-1.2.1%26q%3d80%26w%3d1080&ehk=Gww3MHYoEwaudln4mR6ssDjrAMbAvyoXYMsyKg5p0Ac%3d&risl=&pid=ImgRaw&r=0",
    this.dob = "01.01.1999",
    this.userName = "User Name",
    this.userID = "AB000TY0",
    this.countVehicle = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
      decoration: BoxDecoration(color: Colors.grey.shade50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              badges.Badge(
                badgeColor: Colors.transparent,
                elevation: 0,
                position: badges.BadgePosition.bottomEnd(end: -5, bottom: -5),
                badgeContent: const CircleAvatar(
                  radius: 10,
                    child: Icon(EvaIcons.cameraOutline,
                      size: 12,
                    )),
                child: GestureDetector(
                  onTap: (){
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(userImage),
                  ),
                ),
              ),
              Container(
                width: 180,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        color: Theme.of(context).textTheme.titleMedium!.color,
                        letterSpacing: 1.3,
                      ),
                    ),
                    Text(
                      userID,
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          color: Theme.of(context).textTheme.bodySmall!.color),
                    )
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: editProfile,
                  icon: const Icon(Remix.edit_2_fill))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Date of Birth"),
          Text(dob,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: 5,
          ),
          const Text("Total no of vehicle owned "),
          Text(countVehicle.toString(),
            style: Theme.of(context).textTheme.displaySmall,
          )
        ],
      ),
    );
  }
}
