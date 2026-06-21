import '/services/launcher_service.dart';
import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import '/pages/widget/icon_text_tile.dart';
import '/component/bohiba_appbar/title_appbar.dart';

import '/controllers/share_contoroller.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class ShareEarnPage extends GetView<ShareController> {
  const ShareEarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Share'),
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
                Text("Invite friends",
                    style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'Share your refferral code or link with friends and start building strong community of driver and truck owner.',
                  style: bohibaTheme.textTheme.titleMedium,
                ),
                Gap(ScreenUtils.height20),
                /*TextInputField(
                  hintText: 'Refferal Code',
                  controller: controller.textEditingController,
                  maxLines: 1,
                  readOnly: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SecoundaryButton(
                      onPressed: () async {
                        await LauncherService.shareViaAnyApp();
                      },
                      width: ScreenUtils.width * 0.65,
                      label: 'Share Link',
                    ),
                    PrimaryTextIconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                              text: controller.textEditingController.text),
                        );
                      },
                      width: ScreenUtils.width * 0.25,
                      widget: Icon(Icons.copy_all_outlined),
                      label: 'Copy',
                    )
                  ],
                ),
                Gap(ScreenUtils.height30),*/
                Text('Share your Link via',
                    style: bohibaTheme.textTheme.headlineMedium),
                IconTextTile(
                  icon: Remix.whatsapp_line,
                  text: 'WhatsApp',
                  onTap: () async {
                    await LauncherService.shareAppOnWhatsApp();
                  },
                ),
                IconTextTile(
                  icon: Remix.telegram_2_line,
                  text: 'Telegram',
                  onTap: () async {
                    await LauncherService.shareAppOnTelegram();
                  },
                ),
                IconTextTile(
                  icon: Remix.mail_line,
                  text: 'Mail',
                  onTap: () async {
                    await LauncherService.shareViaEmail();
                  },
                ),
                IconTextTile(
                  icon: Icons.sms_outlined,
                  text: 'SMS',
                  onTap: () async {
                    await LauncherService.shareViaSms();
                  },
                ),
                IconTextTile(
                  icon: Icons.apps,
                  text: 'Other',
                  onTap: () async {
                    await LauncherService.shareViaAnyApp();
                  },
                ),
                Gap(ScreenUtils.height30),
                /*Text('Rewards', style: bohibaTheme.textTheme.headlineMedium),
                LinearBoxWidget(
                  header: 'Friend Joined',
                  title: '1',
                ),
                LinearBoxWidget(
                  header: 'Point Earneds',
                  title: '500',
                ),
                Gap(ScreenUtils.height30),*/
                Text('How it works',
                    style: bohibaTheme.textTheme.headlineMedium),
                IconTextTile(
                  icon: Icons.share_outlined,
                  text: '1. Share',
                  subtitle:
                      'Invite your fellow truck owners and drivers to join Bohiba.',
                ),
                IconTextTile(
                  icon: Remix.user_add_line,
                  text: '2. Grow the Community',
                  subtitle:
                      'The more users join, the stronger and more connected our trucking network becomes.',
                ),
                IconTextTile(
                  icon: Remix.gift_line,
                  text: '3. Benefit Together',
                  subtitle:
                      'A bigger community means better updates, more opportunities, and easier access to trips and resources for everyone.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
