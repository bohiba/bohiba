import '/controllers/master_controller.dart';
import '/services/dio_serivce.dart';

import '/services/pref_utils.dart';

import '/services/permission_service.dart';
import '/routes/app_route.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final MasterController _master =
      Get.put<MasterController>(MasterController());
  final DioService _dio = DioService();
  final PrefUtils _prefUtils = PrefUtils();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await _prefUtils.init();
      await _initApp();
    });
  }

  Future<void> _initApp() async {
    String strToken = _prefUtils.getString(PrefUtils.token);

    Future.delayed(const Duration(seconds: 3), () async {
      if (strToken.isEmpty) {
        Get.offAllNamed(AppRoute.signIn);
      } else {
        _dio.setToken(strToken);
        Get.offAllNamed(AppRoute.navBar);
      }
    });
    if (strToken.isNotEmpty) {
      _dio.setToken(strToken);
      await _master.mainApi();
    }
    await PermissionService.checkAndRequestPermissions();
  }
}
