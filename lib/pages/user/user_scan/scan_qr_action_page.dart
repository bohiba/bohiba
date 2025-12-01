import '/dist/component_exports.dart';
import '/pages/widget/icon_text_tile.dart';
import '/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class ScanQrActionPage extends StatelessWidget {
  const ScanQrActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(title: 'Pick your choice'),
      body: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtils.height25,
          left: ScreenUtils.width15,
          right: ScreenUtils.width15,
        ),
        child: Column(
          children: [
            IconTextTile(
              onTap: () {},
              icon: Remix.profile_line,
              text: 'View Profile',
              subtitle: 'Share your QR code and let next user connect with you',
            ),
            IconTextTile(
              onTap: () {
                navigateState.pushNamed(AppRoute.ratingDriver);
              },
              icon: Remix.star_line,
              text: 'Rating',
              subtitle: 'Scan QR to get connected with driver and truck owner',
            ),
            IconTextTile(
              onTap: () {},
              icon: Icons.person_add_alt_1_outlined,
              text: 'Add Driver',
              subtitle: 'Share your QR code and let next user connect with you',
            ),
          ],
        ),
      ),
    );
  }
}
