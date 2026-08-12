import 'package:bohiba/controllers/home_controller.dart';
import 'package:bohiba/dist/enums/enum_favourite_type.dart';

import '../dist/enums/app_enums.dart';
import '/model/profile_model.dart';
import '/services/profile_service.dart';
import '/services/rating_service.dart';
import '../core/network/dio_serivce.dart';
import '/services/driver_service.dart';

import 'package:get/get.dart';
import '../model/user_model.dart';
import 'package:flutter/material.dart';

class DriverController extends GetxController {
  DioService dioService = DioService();

  RxInt driverId = 0.obs;

  bool addByDoc = false;
  RxBool didReviewed = false.obs;
  RxBool isSelected = false.obs;

  Rx<String> selectedRateMsgIndex = ('').obs;
  Rx<String> strErrorTitle = ''.obs;
  Rx<String> strErrorDesc = ''.obs;

  Rx<double> rateStar = 0.0.obs;
  TextEditingController feedbackCtrl = TextEditingController();

  Rxn<UserModel> driverModel = Rxn<UserModel>();
  Rx<ProfileModel> profileModel = ProfileModel().obs;

  RxList<UserModel> arrDriver = <UserModel>[].obs;
  final List suggestion = [
    'Safe Driver',
    'Need improvement in Driving',
    'Great service',
    'Hard working',
    'Highly recommend',
    'Skillfull'
  ];

  @override
  void onInit() {
    super.onInit();

    Map args = Get.arguments as Map;
    if (args.containsKey('driver_id')) {
      driverId.value = args['driver_id'];
    }

    Future.delayed(Duration.zero, () async {
      await getDriverInfo();
      isRated();
    });
  }

  Future<int> deleteDriver({required int id}) async {
    int success = await DriverService.deleteDriver(driverId: id);
    if (success > 0) {
      // Success
    }
    return success;
  }

  Future<void> getDriverInfo({MethodType methodType = MethodType.local}) async {
    UserModel? driver =
        await DriverService.getDriver(id: driverId.value, type: methodType);
    if (driver != null) {
      driverModel.value = driver;
    }
  }

  Future<ProfileModel?> _getProfile() async {
    ProfileModel? profile = await ProfileService.getProfile();
    if (profile != null) {
      profileModel.value = profile;
      return profile;
    } else {
      strErrorTitle.value = 'Driver not found';
      strErrorDesc.value = 'Sorry, we unable to fetch this driver detail.';
    }
    return null;
  }

  Future<int> rateDriver({
    required String txtUuid,
    required double rating,
    required String txtFeedback,
  }) async {
    int rateSuccess = await RatingService.rateDriver(
      reviewerUuid: txtUuid,
      rating: rating,
      feedback: txtFeedback,
    );
    return rateSuccess;
  }

  /*
   ====================================
   ||              HELPER            ||
   ====================================
   */

  Future<bool> isRated() async {
    await _getProfile();
    if (driverModel.value?.rating == null) return false;
    if (driverModel.value!.rating!.isEmpty) return false;
    bool isReviewed = driverModel.value!.rating
            ?.any((d) => d.reviewerUuid == profileModel.value.uuid) ??
        false;
    didReviewed.value = isReviewed;
    return isReviewed;
  }

  void onSelectMsg(String strSuggestion) {
    feedbackCtrl.clear();
    feedbackCtrl.text = strSuggestion;
    if (selectedRateMsgIndex.value == strSuggestion) {
      feedbackCtrl.clear();
      selectedRateMsgIndex.value = '';
      return;
    }
    selectedRateMsgIndex.value = strSuggestion;
  }

  Future<void> syncFavourite() async {
    Map<String, dynamic> favObj = {
      'asset_type': EnumFavouriteType.driver.index,
      'asset_id': driverModel.value?.id,
    };
    bool success = await DriverService.markFav(favObj: favObj);
    driverModel.value?.isFav = success;
    driverModel.refresh();

    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().refreshFavouriteList();
    }
  }
}
