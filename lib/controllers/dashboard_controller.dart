import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/services/profile_service.dart';

import '/controllers/auth_controller.dart';
import '/model/profile_model.dart';
import '/services/device_info_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DashboardController extends GetxController {
  final AuthController _authController =
      Get.put<AuthController>(AuthController());

  RefreshController refreshProfile = RefreshController();

  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();

  Map<String, dynamic> deviceInfo = {};

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getProfileModel();
    });
  }

  Future<void> onRefreshProfilePage() async {
    await getProfileModel();
    deviceInfo = await DeviceInfoService.getDeviceInfo();
    refreshProfile.refreshCompleted();
  }

  Future<ProfileModel?> getProfileModel({
    MethodType methodType = MethodType.local,
  }) async {
    ProfileModel? profile = await ProfileService.getProfile(type: methodType);
    if (profile != null) {
      profileModel.value = profile;
    }
    return profile;
  }

  Future<void> logout() async {
    return _authController.logout();
  }
}
