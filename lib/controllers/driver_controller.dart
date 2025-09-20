import '/services/api_end_point.dart';

import '/model/profile_model.dart';
import '/model/user_fav_model.dart';
import '/services/db_service.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';

import '/dist/app_enums.dart';
import '/model/driver_model.dart';

import 'package:get/get.dart';

class DriverController extends GetxController {
  DBService dBService = DBService();
  DioService dioService = DioService();

  bool addByDoc = false;
  RxBool didReviewed = false.obs;

  Rx<int> selectedRateMsgIndex = (-1).obs;

  Rx<double> rateStar = 0.0.obs;

  TextEditingController feedbackCtrl = TextEditingController();

  Rx<DriverModel> driverModel = DriverModel().obs;
  Rx<ProfileModel> profileModel = ProfileModel().obs;

  RxList<DriverModel> arrDriver = <DriverModel>[].obs;
  final List suggestion = [
    'Great service',
    'Hard working',
    'Highly recommend',
    'Skillfull'
  ];

  @override
  void onInit() {
    super.onInit();
    DriverModel driver = Get.arguments;
    Future.delayed(Duration.zero, () async {
      await getDriverInfo(id: driver.id!.toString());
      await _getProfile();
      isRated();
    });
  }

  Future<void> toggleFav(
      {required String assetId, required DriverModel driver}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'asset_type': 'drivers',
      'asset_id': assetId,
    };
    ApiResponse response =
        await dioService.post(ApiEndPoint.apiAddFav, body: bodyObj);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        if (response.data != null) {
          UserFavouriteModel favModel =
              UserFavouriteModel.fromJson(response.data);
          int dbSuccess = await dBService.putData<UserFavouriteModel>(
              tblUserFav, favModel.id.toString(), favModel);

          driver.isFav = true;
          int dBSuccess2 = await dBService.putData<DriverModel>(
              tblDriver, favModel.assetId.toString(), driver);

          if (dBSuccess2 > 0 && dbSuccess > 0) {
            GlobalService.showAppToast(message: response.message);
          }
          return;
        }

        if (response.data == null) {
          UserFavouriteModel? favModel =
              await dBService.findSingleData<UserFavouriteModel>(
                  tblUserFav,
                  (item) => (item.assetId.toString() == assetId &&
                      item.assetType == 'drivers'));

          int dBSuccess = await dBService.deleteData<UserFavouriteModel>(
              tblUserFav, favModel!.id!.toString());

          driver.isFav = false;
          int dBSucess2 = await dBService.putData<DriverModel>(
              tblDriver, driver.id.toString(), driver);

          if (dBSuccess > 0 && dBSucess2 > 0) {
            GlobalService.showAppToast(message: response.message);
          }
          return;
        }
        break;
      case 401:
      default:
    }
  }

  Future<void> deleteDriver({required String id}) async {
    if (await DeviceInfoService.hasInternet()) return;
    GlobalService.showProgress();
    ApiResponse response =
        await dioService.delete("${ApiEndPoint.apiDeleteDriver}/$id");
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        int dBSuccess = await dBService.deleteData<DriverModel>(tblDriver, id);
        if (dBSuccess > 0) {
          GlobalService.showAppToast(message: response.message);
          Get.back(result: true);
        }
        break;
      case 401:
        GlobalService.showAppToast(message: response.message);
        break;
      default:
    }
  }

  Future<void> addDriver() async {
    if (await DeviceInfoService.hasInternet()) return;
    GlobalService.showProgress();
    ApiResponse response = await dioService.post(ApiEndPoint.apiAddDriver);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 201:
        DriverModel driver = DriverModel.fromJson(response.data);
        int dBSuccess = await dBService.putData<DriverModel>(
            tblDriver, driver.id!.toString(), driver);
        if (dBSuccess > 0) {
          GlobalService.showAppToast(message: response.message);
        }
        break;
      default:
    }
  }

  Future<DriverModel> getDriverInfo({required String id}) async {
    DriverModel driver =
        await dBService.getData<DriverModel>(tblDriver, id) ?? DriverModel();
    driverModel.value = driver;
    return driver;
  }

  Future<void> updateDriverInfo({required String id}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    ApiResponse response =
        await dioService.get('${ApiEndPoint.apiGetDriver}/$id');
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        DriverModel updatedriver = DriverModel.fromJson(response.data);
        await dBService.putData<DriverModel>(tblDriver, id, updatedriver);
        driverModel.value = updatedriver;
        break;
      case 401:
        GlobalService.showAppToast(message: response.message);
        break;
      default:
    }
  }

  Future<ProfileModel> _getProfile() async {
    ProfileModel profile =
        await dBService.getData<ProfileModel>(tblProfile, profileKey) ??
            ProfileModel();
    profileModel.value = profile;
    return profile;
  }

  Future<void> rateDriver({
    required String txtUuid,
    required double rating,
    required String txtFeedback,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    if (rating == 0.0) {
      GlobalService.showAppToast(message: 'Please rate the user');
      return;
    }

    if (txtFeedback.isEmpty) {
      GlobalService.showAppToast(message: 'Please share your feedback');
      return;
    }
    GlobalService.closeKeyboard();
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'reviewee_uuid': txtUuid,
      'rating': rating,
      'feedback': txtFeedback,
    };
    ApiResponse response =
        await dioService.post(ApiEndPoint.apiRateDriver, body: bodyObj);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 201:
        Get.back(result: true);
        GlobalService.getAlertDialog(
          status: AlertStatus.success,
          title: 'SUCCESS',
          description: response.message,
        );
        break;
      case 401:
        GlobalService.showAppToast(message: response.message);
        break;
      default:
    }
  }

  /*
   ====================================
   ||              HELPER            ||
   ====================================
   */

  void onModalClose() {
    if (rateStar.value != 0 || feedbackCtrl.text.isNotEmpty) {
      GlobalService.showAlertDialog(
        status: AlertStatus.warning,
        title: 'DISCARD',
        description:
            'Do you want to discard you valueable rating and feedback?',
        onDiscard: () {
          rateStar.value = 0.0;
          feedbackCtrl.clear();
          Get.close(2);
        },
        onSave: () {
          Get.close(2);
        },
      );
    } else {
      Get.back();
    }
  }

  bool isRated() {
    if (driverModel.value.rating == null) return false;
    if (driverModel.value.rating!.isEmpty) return false;
    bool isReviewed = driverModel.value.rating
            ?.any((d) => d.reviewer?.uuid == profileModel.value.uuid) ??
        false;
    didReviewed.value = isReviewed;
    return isReviewed;
  }

  void onSelectMsg(int index) {
    feedbackCtrl.clear();
    feedbackCtrl.text = suggestion[index];
    if (selectedRateMsgIndex.value == index) {
      feedbackCtrl.clear();
      selectedRateMsgIndex.value = -1;
      return;
    }
    selectedRateMsgIndex.value = index;
  }
}
