import 'package:bohiba/services/global_service.dart';
import 'package:bohiba/services/user_role_type.dart';

import '/dist/app_enums.dart';
import '/model/profile_model.dart';
import '../model/logged_in_user_model.dart';
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

  RxList<String> truckOwnerStatus = <String>['HIRING', 'NOT HIRING'].obs;
  RxList<String> truckDriverStatus = <String>['LOOKING', 'NOT LOOKING'].obs;
  RxString opted = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getProfileModel();
    });
  }

  Future<void> onRefreshDashPage() async {
    await getProfileModel(methodType: MethodType.api);
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

  Future<void> updateUserHiringStatus() async {
    profileModel.value?.jobStatus =
        opted.value.replaceAll(' ', '_').toLowerCase();
    GlobalService.printHandler(opted.value.replaceAll(' ', '_').toLowerCase());
    ProfileModel? profileInfo = await ProfileService.updateUserProfile(
        bodyMap: {'job_status': profileModel.value?.jobStatus});

    if (profileInfo != null) {
      profileModel.value = profileInfo;
    }
  }

  Future<ProfileModel?> getProfileModel({
    MethodType methodType = MethodType.local,
  }) async {
    ProfileModel? profile = await ProfileService.getProfile(type: methodType);
    if (profile != null) {
      profileModel.value = profile;
    }

    if (profile!.roleId == UserRoles.truckOwner) {
      opted.value =
          profile.jobStatus?.replaceAll('_', ' ').toUpperCase() ?? 'Not Hiring';
    } else {
      opted.value = profile.jobStatus?.replaceAll('_', ' ').toUpperCase() ??
          'Not Looking';
    }
    return profile;
  }
}
