import '/dist/app_enums.dart';
import '/model/profile_model.dart';
import '/model/user_list_model.dart';
import '/services/profile_service.dart';
import '/services/device_info_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DashboardController extends GetxController {
  RefreshController refreshProfile = RefreshController();
  RefreshController refreshDashboard = RefreshController();

  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  RxList<LoggedInAccountModel> arrLoggedInUser = <LoggedInAccountModel>[].obs;
  Rx<LoggedInAccountModel> selectUser = LoggedInAccountModel().obs;

  Map<String, dynamic> deviceInfo = {};

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getProfileModel();
    });
  }

  Future<void> onRefreshDashPage() async {
    await getProfileModel();
    deviceInfo = await DeviceInfoService.getDeviceInfo();
    refreshDashboard.refreshCompleted();
  }

  Future<void> onRefreshProfilePage() async {
    await getProfileModel();
    deviceInfo = await DeviceInfoService.getDeviceInfo();
    refreshProfile.refreshCompleted();
  }

  Future<int> switchAccount() async {
    return await ProfileService.switchAccount(user: selectUser.value);
  }

  Future<void> getLoggedUserAccount() async {
    List<LoggedInAccountModel> arrList =
        await ProfileService.getLoggedAccount();
    arrLoggedInUser.clear();
    arrLoggedInUser.addAll(arrList);
    selectUser.value = arrLoggedInUser
        .where((user) => (user.uuid == profileModel.value!.uuid!))
        .toList()
        .first;
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
