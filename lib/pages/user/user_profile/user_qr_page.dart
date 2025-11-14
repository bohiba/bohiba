import '/controllers/user_qr_controller.dart';
import '/dist/component_exports.dart';
import '/pages/widget/icon_text_tile.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_bar_code/qr/qr.dart';
import 'package:remixicon/remixicon.dart';

import 'user_profile_component/user_profile_card.dart';

class UserQrPage extends GetView<UserQrController> {
  const UserQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(title: 'Scanner'),
      body: Container(
        height: ScreenUtils.height,
        padding: EdgeInsets.only(
          top: ScreenUtils.height10,
          left: ScreenUtils.width15,
          right: ScreenUtils.width15,
        ),
        child: Obx(() {
          if (controller.profileModel.value == null) {
            return SizedBox.shrink();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserProfileCard(
                  userImage: controller.profileModel.value?.image ?? '',
                  userName: controller.profileModel.value?.name,
                  userID: controller.profileModel.value?.uuid,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  child: QRCode(
                    data: controller.encryptUuid(),
                    size: 210.h,
                    eyeStyle: QREyeStyle(
                      eyeShape: QREyeShape.square,
                      color: bohibaTheme.primaryColor,
                    ),
                    dataModuleStyle: QRDataModuleStyle(
                      dataModuleShape: QRDataModuleShape.square,
                      color: bohibaTheme.primaryColor,
                    ),
                  ),
                ),
                IconTextTile(
                  onTap: () {
                    navigateState.pushNamed(AppRoute.userScanQrPage);
                  },
                  icon: Remix.qr_scan_line,
                  text: 'Scan',
                  subtitle:
                      'Scan QR to get connected with driver and truck owner',
                ),
                IconTextTile(
                  onTap: () {},
                  icon: Icons.share_outlined,
                  text: 'Share QR Code',
                  subtitle:
                      'Share your QR code and let next user connect with you',
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
