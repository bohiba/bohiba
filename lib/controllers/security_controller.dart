import '/services/auth_service.dart';
import '/services/device_info_service.dart';
import 'package:get/get.dart';

class SecurityController extends GetxController {
  RxMap<String, dynamic> appInfo = <String, dynamic>{}.obs;
  RxBool isBioMetricEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getAppInfo();
      getBiometricInfo();
    });
  }

  Future<void> setBioMetric({required bool enable}) async {
    await DeviceInfoService.setBioMetric(isEnable: enable);

    if (enable) {}
  }

  Future<void> getBiometricInfo() async {
    isBioMetricEnabled.value = DeviceInfoService.isBioMetricEnabled();
  }

  Future<void> getAppInfo() async {
    appInfo.value = await DeviceInfoService.getAppInfo();
  }

  Future<int> logOut() async {
    int success = await AuthService.logOut();
    return success;
  }
}
