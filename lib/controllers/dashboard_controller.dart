import '/controllers/home_controller.dart';
import '/services/global_service.dart';
import '/services/user_role_type.dart';

import '../dist/enums/app_enums.dart';
import '/model/profile_model.dart';
import '../model/logged_in_user_model.dart';
import '/services/profile_service.dart';
import '/services/device_info_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DashboardController extends GetxController {
  HomeController homeController = Get.find<HomeController>();
  RefreshController refreshProfile = RefreshController();
  RefreshController refreshDashboard = RefreshController();

  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  RxList<LoggedInAccountModel> arrLoggedInUser = <LoggedInAccountModel>[].obs;
  Rx<LoggedInAccountModel> selectUser = LoggedInAccountModel().obs;

  Map<String, dynamic> deviceInfo = {};

  RxList<String> statusOption = <String>[].obs;

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
    await getProfileModel(methodType: MethodType.api);
    deviceInfo = await DeviceInfoService.getDeviceInfo();
    refreshProfile.refreshCompleted();
  }

  Future<int> switchAccount() async {
    return await ProfileService.switchAccount(user: selectUser.value);
  }

  Future<void> getLoggedUserAccount() async {
    List<LoggedInAccountModel> arrList = await ProfileService.getLoggedAccount();
    arrLoggedInUser.clear();
    arrLoggedInUser.addAll(arrList);
    List<LoggedInAccountModel> arrUserList = arrList.where((user) => (user.uuid == profileModel.value!.uuid!)).toList();
    if (arrUserList.isNotEmpty) {
      selectUser.value = arrUserList.first;
    }
  }

  Future<void> updateUserHiringStatus() async {
    // TODO: Make this functional as eariler it was taking string but now it is taking int
    // profileModel.value?.jobStatus = opted.value.replaceAll(' ', '_').toLowerCase();
    GlobalService.printHandler(opted.value.replaceAll(' ', '_').toLowerCase());
    ProfileModel? profileInfo = await ProfileService.updateUserProfile(bodyMap: {'job_status': profileModel.value?.jobStatus});

    if (profileInfo != null) {
      profileModel.value = profileInfo;
    }
  }

  Future<ProfileModel?> getProfileModel({
    MethodType methodType = MethodType.local,
    bool showLoading = false,
  }) async {
    ProfileModel? profile = await ProfileService.getProfile(type: methodType, showProgress: showLoading);
    if (profile != null) {
      profileModel.value = profile;
      if (profile.roleId == UserRoles.truckOwner) {
        statusOption.value = ['HIRING', 'NOT HIRING'];
        opted.value = profile.jobStatus == 1 ? 'HIRING' : 'NOT HIRING';
      } else {
        statusOption.value = ['LOOKING', 'NOT LOOKING'];
        opted.value = profile.jobStatus == 1 ? 'LOOKING' : 'NOT LOOKING';
      }
      homeController.profile.value = profile;
      return profile;
    }

    return null;
  }
}
