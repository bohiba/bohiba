import '/services/global_service.dart';
import '/services/dio_serivce.dart';
import '/services/truck_service.dart';
import '/dist/app_enums.dart';
import '/model/truck_model.dart';
import '/controllers/master_controller.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class TruckAllController extends GetxController {
  final RefreshController refreshTruckList = RefreshController();
  final TextEditingController vehicleNumberController = TextEditingController();

  DioService dioService = DioService();

  Rx<AddAssetUsing> addAsset = AddAssetUsing.scan.obs;

  // Driver Details
  RxList<TruckModel> arrTruck = <TruckModel>[].obs;

  RxBool isFav = false.obs;
  bool showLeading = true;

  @override
  void onInit() {
    Map? routeInfo = Get.arguments;
    if (routeInfo != null) {
      showLeading = routeInfo['showLeading'];
    }

    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getTruckList();
    });
  }

  Future<int> deleteTruck({required int truckId}) async {
    int success = await TruckService.deleteTruck(truckId: truckId);
    return success;
  }

  Future<List<TruckModel>> getTruckList({
    MethodType methodType = MethodType.local,
    bool resetList = false,
  }) async {
    List<TruckModel> truckList =
        await TruckService.getTruckList(type: methodType, reset: resetList);
    arrTruck.clear();
    arrTruck.addAll(truckList);
    return arrTruck;
  }

  Future<int> addVehicle() async {
    if (vehicleNumberController.text.isEmpty) {
      GlobalService.showSnackBar(
        status: AlertStatus.warning,
        title: 'Truck',
        desc: 'Please enter truck number',
      );
      return 0;
    }
    int model = await TruckService.createTruck(
      vehicleNumber: vehicleNumberController.text.trim().toUpperCase(),
    );
    if (model > 0) {
      vehicleNumberController.clear();
    }
    return model;
  }

  bool notifyFavouriteListner({bool markedFav = false}) {
    isFav.value = markedFav;
    return isFav.value;
  }

  @override
  void dispose() {
    vehicleNumberController.dispose();
    Get.delete<MasterController>();
    super.dispose();
  }
}
