import '/theme/theme_changer.dart';

import '/controllers/auth_controller.dart';
import '/model/profile_model.dart';
import '/services/db_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DashboardController extends GetxController {
  final AuthController _authController =
      Get.put<AuthController>(AuthController());
  final ThemeController themeChanger = Get.find<ThemeController>();

  RefreshController refreshProfile = RefreshController();
  final DBService _dbService = DBService();

  RxBool isSwitchedA = false.obs;

  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      isSwitchedA.value = themeChanger.isDarkMode;
      await getProfileModel();
    });
  }

  Future<void> onRefreshProfilePage() async {
    await getProfileModel();
    refreshProfile.refreshCompleted();
  }

  Future<ProfileModel> getProfileModel() async {
    return profileModel.value =
        await _dbService.getData<ProfileModel>(tblProfile, profileKey) ??
            ProfileModel();
  }

  Future<void> logout() async {
    return _authController.logout();
  }
}
