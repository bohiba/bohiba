import '/dist/app_enums.dart';
import '/model/profile_model.dart';
import '/services/user_role_type.dart';
import '/services/dio_serivce.dart';
import '/services/device_info_service.dart';
import '/services/pref_utils.dart';
import '/services/permission_service.dart';
import '/routes/app_route.dart';

import 'package:get/get.dart';

import 'master_controller.dart';

class SplashController extends GetxController {
  final MasterController _master =
      Get.put<MasterController>(MasterController());
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
    Future.delayed(const Duration(seconds: 3), () async {
      if (strToken.isEmpty) {
        Get.offAllNamed(AppRoute.signIn);
      } else if (strToken.isNotEmpty) {
        _dio.setToken(strToken);
        final ProfileModel? profileModel =
            await _master.profileApi(methodType: MethodType.api);
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
              await _master.mainApi();
              Get.offAllNamed(AppRoute.navBar);
            } else {
              // Navigate to Lock Screen
            }
          } else {
            await _master.mainApi();
            Get.offAllNamed(AppRoute.navBar);
          }
        }
      }
    });

    await PermissionService.reqLocPermission();
  }
}
