import '/dist/enums/app_enums.dart';
import '/routes/app_route.dart';
import '/model/profile_model.dart';
import '/services/db2_service.dart';
import '/services/firebase_app_service.dart';
import '/services/main_service.dart';
import '/services/pref_utils.dart';
import '../core/network/dio_serivce.dart';
import '/services/user_role_type.dart';
import '/services/profile_service.dart';
import '/services/device_info_service.dart';
import '/controllers/role_controller.dart';
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
    bool isBioMetricEnabled = DeviceInfoService.isBioMetricEnabled();
    Future.delayed(
      Duration.zero,
      () async {
        await Future.wait([
          FirebaseAppService.initFirebase(),
          PrefUtils.init(),
          DatabaseService().initDB(),
        ]);
        String strToken = _prefUtils.getString(PrefUtils.token);
        if (strToken.isEmpty) {
          Get.offAllNamed(AppRoute.signIn);
        } else if (strToken.isNotEmpty) {
          MethodType methodType = await DeviceInfoService.hasInternet() ? MethodType.api : MethodType.local;
          _dio.setToken(strToken);
          final ProfileModel? profileModel = await ProfileService.getProfile(
            type: methodType,
            showProgress: false,
          );
          int userRole = RoleService.initRole(profileModel);
          if (profileModel == null) {
            Get.offAllNamed(AppRoute.signIn);
            return;
          } else if (profileModel.mobileNumber == null) {
            Get.offAllNamed(AppRoute.signIn);
            return;
          } else if (profileModel.pinCode == null) {
            Get.offAllNamed(AppRoute.userAddressAuthScreen);
            return;
          } else if (userRole == UserRoles.guest) {
            Get.offAllNamed(AppRoute.roleType);
          } else {
            Future.wait([
              MainService.mainApi(type: methodType, showProgress: false),
              FirebaseAppService.registerToken(),
            ]);
            if (isBioMetricEnabled == true) {
              bool success = await DeviceInfoService.authenticateUser();
              if (success) {
                if (userRole == UserRoles.truckOwner) {
                  Get.offAllNamed(AppRoute.truckOwnerNavBar);
                } else if (userRole == UserRoles.driver) {
                  Get.offAllNamed(AppRoute.truckDriverNavBar);
                }
              } else {
                // Navigate to Lock Screen
                Get.offAllNamed(
                  AppRoute.biometricAuth,
                  arguments: profileModel,
                );
              }
            } else {
              if (userRole == UserRoles.truckOwner) {
                Get.offAllNamed(AppRoute.truckOwnerNavBar);
              } else if (userRole == UserRoles.driver) {
                Get.offAllNamed(AppRoute.truckDriverNavBar);
              }
            }
          }
        }
      },
    );
  }
}
