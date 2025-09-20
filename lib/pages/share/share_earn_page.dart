import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';
import 'package:bohiba/component/bohiba_buttons/primary_icon_button.dart';
import 'package:bohiba/component/bohiba_buttons/secoundary_button.dart';
import 'package:bohiba/component/bohiba_inputfield/text_inputfield.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/widget/icon_text_tile.dart';
import 'package:bohiba/pages/widget/linear_box_widget.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class ShareEarnPage extends StatelessWidget {
  const ShareEarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Share and Earn'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height20,
              left: ScreenUtils.width15,
              right: ScreenUtils.width15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Invite friends and earn rewards",
                    style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'Share your refferral code or link with friends When they join and complete their first trip, both you`ll both earn rewards.',
                  style: bohibaTheme.textTheme.titleMedium,
                ),
                Gap(ScreenUtils.height20),
                TextInputField(
                  hintText: 'Refferal Code',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SecoundaryButton(
                      onPressed: () {},
                      width: ScreenUtils.width * 0.65,
                      label: 'Share Link',
                    ),
                    PrimaryTextIconButton(
                      onPressed: () {},
                      width: ScreenUtils.width * 0.25,
                      widget: Icon(Icons.copy_all_outlined),
                      label: 'Copy',
                    )
                  ],
                ),
                Gap(ScreenUtils.height30),
                Text('Share your Link via',
                    style: bohibaTheme.textTheme.headlineMedium),
                IconTextTile(
                  icon: Remix.whatsapp_line,
                  text: 'WhatsApp',
                ),
                IconTextTile(
                  icon: Remix.telegram_2_line,
                  text: 'Telegram',
                ),
                IconTextTile(
                  icon: EvaIcons.emailOutline,
                  text: 'Mail',
                ),
                IconTextTile(
                  icon: Icons.sms_outlined,
                  text: 'SMS',
                ),
                Gap(ScreenUtils.height30),
                Text('Rewards', style: bohibaTheme.textTheme.headlineMedium),
                LinearBoxWidget(
                  header: 'Friend Joined',
                  title: '1',
                ),
                LinearBoxWidget(
                  header: 'Point Earneds',
                  title: '500',
                ),
                Gap(ScreenUtils.height30),
                Text('How it works',
                    style: bohibaTheme.textTheme.headlineMedium),
                IconTextTile(
                  icon: Icons.share_outlined,
                  text: '1. Share',
                  subtitle:
                      'Share your refferal link or code with you friends.',
                ),
                IconTextTile(
                  icon: EvaIcons.personAddOutline,
                  text: '2. Sign Up',
                  subtitle: 'Your friend signup using your refferal.',
                ),
                IconTextTile(
                  icon: EvaIcons.giftOutline,
                  text: '3. Earn',
                  subtitle:
                      'Once they complete their first trip, you both will get rewards.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
