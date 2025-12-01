import '/model/user_model.dart';
import 'package:flutter/material.dart';

import '/services/rating_service.dart';
import 'package:get/get.dart';

class DriverRatingController extends GetxController {
  Rxn<UserModel> driverModel = Rxn<UserModel>();

  TextEditingController feedbackCtrl = TextEditingController();

  Rx<double> rateStar = 0.0.obs;
  RxBool isSelected = false.obs;
  RxBool didReviewed = false.obs;

  Rx<String> selectedRateMsgIndex = ('').obs;

  final List suggestion = ['Safe Driver', 'Need improvement in Driving', 'Great service', 'Hard working', 'Highly recommend', 'Skillfull'];

  @override
  void onInit() {
    driverModel.value = Get.arguments;
    super.onInit();
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
}
