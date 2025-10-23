import '/dist/app_enums.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/model/trip_model.dart';
import '/services/global_service.dart';
import '/services/trip_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  RefreshController refreshController = RefreshController();

  Rx<TripModel> tripInfo = TripModel().obs;

  @override
  void onInit() {
    super.onInit();
    TripModel? t = Get.arguments;
    Future.delayed(Duration.zero, () async {
      if (t != null) {
        await getTripInfo(id: t.id!);
      }
    });
  }

  Future<void> refreshTripPage() async {
    await getTripInfo(
      id: tripInfo.value.id!,
      methodType: MethodType.api,
      showLoading: false,
    );
    refreshController.refreshCompleted();
  }

  Future<void> getTripInfo({
    MethodType methodType = MethodType.local,
    bool showLoading = true,
    required int id,
  }) async {
    TripModel? tripModel = await TripService.getTrip(
        method: methodType, tripId: id, showProgress: showLoading);
    if (tripModel != null) {
      tripInfo.value = tripModel;
    }
  }

  Future<void> deleteTrip({required int tripId}) async {
    int deleteSucess = await TripService.deleteTrip(tripId: tripId);
    if (deleteSucess > 0) {
      Get.back();
      Get.back(result: true);
    } else {
      GlobalService.showAppToast(
          message: 'Something went wrong. Please try again.');
      return;
    }
  }

  Color statusColor() {
    switch (tripInfo.value.tripStatus) {
      case 'in_transit':
        return bohibaTheme.colorScheme.secondary;

      case 'delay':
        return bohibaTheme.colorScheme.onSurface;

      case 'completed':
        return bohibaTheme.colorScheme.onSurface;

      case 'cancelled':
        return bohibaTheme.colorScheme.error;

      case 'delayed':
        return bohibaTheme.colorScheme.error;

      case 'on_hold':
        return bohibaTheme.colorScheme.primary;
      default:
        return bohibaTheme.textTheme.titleLarge!.color!;
    }
  }

  @override
  void onClose() {
    tripInfo.close();
    super.onClose();
  }
}
