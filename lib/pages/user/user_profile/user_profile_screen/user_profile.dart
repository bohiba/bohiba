import 'package:bohiba/pages/user/user_profile/edit_user_profile_screen.dart';
import 'package:bohiba/pages/user/user_profile/user_profile_component/user_profile_card.dart';
import 'package:bohiba/pages/user/user_profile/user_profile_component/user_profile_contact_card_component.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  final String profileImg =
      "https://th.bing.com/th/id/R.4b1ebbdf9a6a42f23de2678c80eb02df?rik=SEPvooeqfgw0kA&riu=http%3a%2f%2fimages.unsplash.com%2fphoto-1535713875002-d1d0cf377fde%3fcrop%3dentropy%26cs%3dtinysrgb%26fit%3dmax%26fm%3djpg%26ixid%3dMnwxMjA3fDB8MXxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8fDB8fHx8MTYyNTY2NzI4OQ%26ixlib%3drb-1.2.1%26q%3d80%26w%3d1080&ehk=Gww3MHYoEwaudln4mR6ssDjrAMbAvyoXYMsyKg5p0Ac%3d&risl=&pid=ImgRaw&r=0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TitleAppbar(
          title: "Profile",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileCard(
                userImage:
                    "https://th.bing.com/th/id/R.4b1ebbdf9a6a42f23de2678c80eb02df?rik=SEPvooeqfgw0kA&riu=http%3a%2f%2fimages.unsplash.com%2fphoto-1535713875002-d1d0cf377fde%3fcrop%3dentropy%26cs%3dtinysrgb%26fit%3dmax%26fm%3djpg%26ixid%3dMnwxMjA3fDB8MXxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8fDB8fHx8MTYyNTY2NzI4OQ%26ixlib%3drb-1.2.1%26q%3d80%26w%3d1080&ehk=Gww3MHYoEwaudln4mR6ssDjrAMbAvyoXYMsyKg5p0Ac%3d&risl=&pid=ImgRaw&r=0",
                userName: "Mangal Kishore Mahanta",
                userID: "6ZX096CT",
                countVehicle: 2,
                editProfile: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditUserProfileScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              const UserProfileContactCardComponent(
                header: "Contact Details",
                phoneNumber: "+91 000 000 0000",
                email: "your-mail@example.com",
                address: "Bonai Sundergarh Odisha 770040",
              )
            ],
          ),
        ));
  }
}
