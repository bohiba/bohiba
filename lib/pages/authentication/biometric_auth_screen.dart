import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/dist/component_exports.dart';
import '/controllers/biometric_auth_controller.dart';
import '/theme/bohiba_theme.dart';

class BiometricAuthScreen extends GetView<BiometricAuthController> {
  const BiometricAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bohibaTheme.scaffoldBackgroundColor,
      appBar: TitleAppbar(
        showLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              EvaIcons.logOutOutline,
              size: ScreenUtils.height15.h,
              color: bohibaTheme.colorScheme.tertiary,
            ),
            onPressed: () {
              controller.logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50.h),
            // Profile Image
            Obx(() => Container(
                  decoration: BoxDecoration(
                    color: bohibaTheme.colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(55.r),
                    child: CachedNetworkImage(
                      imageUrl: controller.userImage.value,
                      height: 110.r,
                      width: 110.r,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 50,
                        color: bohibaTheme.colorScheme.onSurface,
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(),
                    ),
                  ),
                )),
            SizedBox(height: 20.h),
            Obx(
              () => Text(
                controller.userName.value,
                style: bohibaTheme.textTheme.bodyLarge,
              ),
            ),
            SizedBox(height: 5.h),
            // User ID
            Obx(
              () => Text(
                controller.userId.value,
                style: bohibaTheme.textTheme.bodyMedium,
              ),
            ),

            SizedBox(height: 50.h),

            // Biometric Login Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.w),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async => await controller.authenticateWithBiometrics(),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: bohibaTheme.primaryColor),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.fingerprint, color: bohibaTheme.primaryColor),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            "Login with biometric",
                            style: bohibaTheme.textTheme.bodyMedium?.copyWith(
                              color: bohibaTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16, color: bohibaTheme.primaryColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Spacer(),

            // Footer
            Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.security, size: 16, color: bohibaTheme.primaryColor),
                  SizedBox(width: 5.w),
                  Text(
                    "ZERODHA",
                    style: TextStyle(color: bohibaTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                ]),
                SizedBox(height: 8.h),
                Text(
                  "SEBI Registration: INZ000031633",
                  style: bohibaTheme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                Text(
                  "CDSL - SEBI Registration: IN-DP-431-2019",
                  style: bohibaTheme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 20.h),
              ],
            )
          ],
        ),
      ),
    );
  }
}
