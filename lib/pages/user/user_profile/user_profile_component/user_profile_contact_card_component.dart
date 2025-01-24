import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';

class UserProfileContactCardComponent extends StatelessWidget {
  final String header;
  final String phoneNumber;
  final String email;
  final String address;

  const UserProfileContactCardComponent({
    super.key,
    this.header = "Header",
    this.phoneNumber = "+91- 000 000 0000",
    this.email = "your-mail@example.com",
    this.address = "City State District Pin-Code",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: BohibaResponsiveScreen.width15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: BohibaResponsiveScreen.height10),
            child: Text(
              header,
              maxLines: 2,
              style: bohibaTheme.textTheme.headlineLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: BohibaResponsiveScreen.height5),
            child: Text(
              phoneNumber,
              style: bohibaTheme.textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: BohibaResponsiveScreen.height5),
            child: Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: bohibaTheme.textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: BohibaResponsiveScreen.height5),
            child: Text(
              address,
              maxLines: 2,
              style: bohibaTheme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
