import '/dist/app_enums.dart';

import '/model/profile_model.dart';
import '/services/main_service.dart';
import '/services/profile_service.dart';
import '/services/user_role_type.dart';
import '/services/dio_serivce.dart';
import '/services/device_info_service.dart';
import '/services/pref_utils.dart';
import '/services/permission_service.dart';
import '/routes/app_route.dart';

import 'package:get/get.dart';

class SplashController extends GetxController {
  final DioService _dio = DioService();
  final PrefUtils _prefUtils = PrefUtils();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await _initApp();
    });
  }

  Future<void> _initApp() async {
    String strToken = _prefUtils.getString(PrefUtils.token);
    bool isBioMetricEnabled = DeviceInfoService.isBioMetricEnabled();
    Future.delayed(Duration.zero, () async {
      if (strToken.isEmpty) {
        Get.offAllNamed(AppRoute.signIn);
      } else if (strToken.isNotEmpty) {
        MethodType methodType = await DeviceInfoService.hasInternet()
            ? MethodType.api
            : MethodType.local;
        _dio.setToken(strToken);
        final ProfileModel? profileModel =
            await ProfileService.getProfile(type: methodType);
        if (profileModel == null) {
          Get.offAllNamed(AppRoute.signIn);
          return;
        } else if (profileModel.mobileNumber == null) {
          Get.offAllNamed(AppRoute.signIn);
          return;
        } else if (profileModel.verification?.pinCode == null) {
          Get.offAllNamed(AppRoute.userAddressAuthScreen);
          return;
        } else if (profileModel.roleId == UserRoles.guest) {
          Get.offAllNamed(AppRoute.roleType);
        } else {
          if (isBioMetricEnabled == true) {
            bool success = await DeviceInfoService.authenticateUser();
            if (success) {
              await MainService.mainApi(type: methodType);
              Get.offAllNamed(AppRoute.navBar);
            } else {
              // Navigate to Lock Screen
            }
          } else {
            await MainService.mainApi(type: methodType);
            Get.offAllNamed(AppRoute.navBar);
          }
        }
      } else {
        await MainService.mainApi();
        Get.offAllNamed(AppRoute.navBar);
      }
    });

    await PermissionService.reqLocPermission();
  }
}
