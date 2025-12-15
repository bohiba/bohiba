import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/routes/app_route.dart';
import 'package:bohiba/services/device_info_service.dart';
import 'package:bohiba/services/user_role_type.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AppBiometricAuthDialog extends StatefulWidget {
  final int role;
  const AppBiometricAuthDialog({super.key, required this.role});

  @override
  State<AppBiometricAuthDialog> createState() => _AppBiometricAuthDialogState();
}

class _AppBiometricAuthDialogState extends State<AppBiometricAuthDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      bool success = await DeviceInfoService.authenticateUser();
      if (success) {
        if (widget.role == UserRoles.truckOwner) {
          Get.offAllNamed(AppRoute.truckOwnerNavBar);
        } else if (widget.role == UserRoles.driver) {
          Get.offAllNamed(AppRoute.truckDriverNavBar);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.height15,
          vertical: ScreenUtils.height25,
        ),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm using your fingerprint',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                  fontFamily: bohibaTheme.textTheme.headlineMedium!.fontFamily,
                  fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                ),
              ),
              Gap(35.h),
              Icon(
                Icons.fingerprint_rounded,
                color: bohibaTheme.primaryColor,
                size: 48.h,
              ),
              Gap(15.h),
              Text(
                "Touch the fingerprint sensor",
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.titleSmall!.fontSize,
                  fontWeight: bohibaTheme.textTheme.titleLarge!.fontWeight,
                  color: bohibaTheme.textTheme.titleMedium!.color,
                ),
              ),
              Gap(25.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Use PIN',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                    fontFamily: bohibaTheme.textTheme.titleMedium!.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
