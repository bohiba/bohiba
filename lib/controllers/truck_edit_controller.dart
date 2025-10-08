import '/services/driver_service.dart';
import '/services/truck_service.dart';
import '/services/api_end_point.dart';

import '/model/driver_model.dart';
import '/model/truck_model.dart';
import '/services/db_service.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTruckController extends GetxController
    with GetSingleTickerProviderStateMixin {
  DioService dioService = DioService();
  DBService dBService = DBService();

  final TextEditingController assignDriverCtlr = TextEditingController();
  late AnimationController rotationController;

  RxList<DriverModel> arrDriver = <DriverModel>[].obs;

  RxBool isDriverAssigned = false.obs;
  RxBool isRotating = false.obs;

  Rx<DriverModel> driverModel = DriverModel().obs;
  Rx<TruckModel> truck = TruckModel().obs;

  @override
  void onInit() {
    truck.value = Get.arguments as TruckModel;
    if (truck.value.driver == null) {
      isDriverAssigned.value = false;
    } else {
      isDriverAssigned.value = true;
    }

    super.onInit();
    Future.delayed(Duration.zero, () async {
      await _getDriverList();
    });

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    rotationController.dispose();
    super.onClose();
  }

  Future<void> _getDriverList() async {
    List<DriverModel>? driverList = await DriverService.getAllDriver();
    if (driverList != null) {
      arrDriver.clear();
      arrDriver.addAll(driverList);
    }
  }

  Future<void> assignDriver({required DriverModel driverInfo}) async {
    if (driverInfo.profile?.driverUuid == null) {
      GlobalService.showAppToast(message: 'Please select driver');
      return;
    }
    int assigned = await TruckService.assignDriver(
      oldTruck: truck.value,
      driver: driverInfo,
    );

    if (assigned > 0) {
      TruckModel? updatedTruck =
          await TruckService.getTruck(truckId: truck.value.id!);
      if (updatedTruck != null) {
        truck.value = updatedTruck;
        isDriverAssigned.value = true;
      }
    }
  }

  Future<void> removeDriver({required TruckModel truckInfo}) async {
    int success = await TruckService.removeDriver(oldTruck: truckInfo);
    if (success > 0) {
      TruckModel? updatedTruck =
          await TruckService.getTruck(truckId: truck.value.id!);
      if (updatedTruck != null) {
        truck.value = updatedTruck;
        isDriverAssigned.value = false;
      }
    }
  }

  Future<TruckModel> getTruckInfo({required String regdNumber}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return TruckModel();
    }
    GlobalService.closeKeyboard();
    GlobalService.showProgress();
    ApiResponse response = await dioService
        .get('${ApiEndPoint.apiGetTruck}?value=$regdNumber&type=0');
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        TruckModel truck = TruckModel.fromJson(response.data);
        int dBSucess = await dBService.putData<TruckModel>(
            tblTrucks, truck.id.toString(), truck);
        if (dBSucess > 0) {
          GlobalService.printHandler('Truck Updated Sucessfully.');
        }
        return truck;
      default:
        return TruckModel();
    }
  }

  // TODO: Update Vechile API
  void toggleRotation() {
    if (isRotating.value) {
      rotationController.stop();
      isRotating.value = false;
    } else {
      rotationController.repeat();
      isRotating.value = true;
    }
  }
}
