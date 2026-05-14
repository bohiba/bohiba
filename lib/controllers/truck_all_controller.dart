import '/services/global_service.dart';
import '../core/network/dio_serivce.dart';
import '/services/truck_service.dart';
import '../dist/enums/app_enums.dart';
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
  Rxn<List<TruckModel>> arrTruck = Rxn<List<TruckModel>>();

  RxBool isFav = false.obs;

  RxInt countUpdate = 0.obs;

  RxString strErrorDes = ''.obs;
  RxString strErrorTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getTruckList(showLoading: false);
    });
  }

  Future<void> getTruckList({
    MethodType methodType = MethodType.local,
    bool resetList = false,
    bool showLoading = false,
  }) async {
    arrTruck.value = null;
    List<TruckModel>? truckList = await TruckService.getTruckList(
      type: methodType,
      reset: resetList,
      showProgress: showLoading,
    );
    if (truckList != null) {
      arrTruck.value = List<TruckModel>.from(truckList);
    } else {
      strErrorTitle.value = 'Truck Not Found';
      strErrorDes.value = 'Add a driver to assign them to a truck and start trips quickly';
    }
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
      countUpdate++;
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
