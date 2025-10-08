import '/dist/app_enums.dart';
import '/model/profile_model.dart';
import '/model/user_list_model.dart';
import '/services/profile_service.dart';
import '/services/device_info_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DashboardController extends GetxController {
  RefreshController refreshProfile = RefreshController();

  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  RxList<UserListModel> arrLoggedInUser = <UserListModel>[].obs;

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

  Future<void> getLoggedUserAccount() async {
    List<UserListModel> arrList = await ProfileService.getLoggedAccount();
    arrLoggedInUser.clear();
    arrLoggedInUser.addAll(arrList);
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
}
