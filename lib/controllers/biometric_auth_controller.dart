import 'package:get/get.dart';
import '/model/profile_model.dart';
import '/services/device_info_service.dart';
import '/services/user_role_type.dart';
import '/routes/app_route.dart';
import '/services/pref_utils.dart';

class BiometricAuthController extends GetxController {
  final PrefUtils _prefUtils = PrefUtils();

  RxString userName = ''.obs;
  RxString userImage = ''.obs;
  RxString userId = ''.obs;

  ProfileModel? _profileModel;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ProfileModel) {
      _profileModel = Get.arguments;
      userName.value = _profileModel?.name ?? 'User';
      userImage.value = _profileModel?.image ?? '';
      userId.value = _profileModel?.uuid ?? '';
    }
  }

  Future<void> authenticateWithBiometrics() async {
    bool success = await DeviceInfoService.authenticateUser();
    if (success && _profileModel != null) {
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() {
    int userRole = _profileModel!.roleId ?? UserRoles.guest;
    if (userRole == UserRoles.truckOwner) {
      Get.offAllNamed(AppRoute.truckOwnerNavBar);
    } else if (userRole == UserRoles.driver) {
      Get.offAllNamed(AppRoute.truckDriverNavBar);
    } else {
      // Default fallback or handle other roles if necessary
      Get.offAllNamed(AppRoute.signIn);
    }
  }

  Future<void> logout() async {
    await _prefUtils.clearPreferencesData();
    Get.offAllNamed(AppRoute.signIn);
  }
}
