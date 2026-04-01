import '../dist/enums/app_enums.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/model/trip_model.dart';
import '/services/trip_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  RefreshController refreshController = RefreshController();

  Rxn<TripModel> tripInfo = Rxn<TripModel>();

  RxString strErrorTitle = ''.obs;
  RxString strErrorDesc = ''.obs;

  @override
  void onInit() {
    super.onInit();
    TripModel? t = Get.arguments;
    Future.delayed(Duration.zero, () async {
      if (t != null && t.id != null) {
        await getTripInfo(id: t.id!);
      }
    });
  }

  Future<void> refreshTripPage() async {
    await getTripInfo(
      id: tripInfo.value!.id!,
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
    TripModel? tripModel = await TripService.getTrip(method: methodType, tripId: id, showProgress: showLoading);
    if (tripModel != null) {
      tripInfo.value = tripModel;
    } else {
      strErrorTitle.value = 'Trip Not Found';
      strErrorDesc.value = 'Sorry we unable to find this trip';
    }
  }

  Future<int> deleteTrip({required int tripId}) async {
    int deleteSucess = await TripService.deleteTrip(tripId: tripId);
    return deleteSucess;
  }

  Color statusColor() {
    switch (tripInfo.value?.tripStatus) {
      case 0:
        return bohibaTheme.colorScheme.secondary.withValues(alpha: 0.85);

      case 1:
        return bohibaTheme.colorScheme.onSurface.withValues(alpha: 0.85);

      case 2:
        return bohibaTheme.colorScheme.secondary.withValues(alpha: 0.85);

      case 3:
        return bohibaTheme.colorScheme.error.withValues(alpha: 0.85);

      case 4:
        return bohibaTheme.colorScheme.error.withValues(alpha: 0.85);

      case 5:
        return bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.65);

      case 9:
        return bohibaTheme.colorScheme.tertiary.withValues(alpha: 0.65);

      default:
        return bohibaTheme.colorScheme.primary.withValues(alpha: 0.85);
    }
  }

  @override
  void onClose() {
    tripInfo.close();
    super.onClose();
  }
}
