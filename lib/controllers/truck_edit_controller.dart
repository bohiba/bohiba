import '../model/user_model.dart';
import '/model/truck_model.dart';
import '/services/driver_service.dart';
import '/services/truck_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTruckController extends GetxController with GetSingleTickerProviderStateMixin {
  DioService dioService = DioService();

  final TextEditingController assignDriverCtlr = TextEditingController();
  late AnimationController rotationController;

  RxList<UserModel> arrDriver = <UserModel>[].obs;

  RxBool isDriverAssigned = false.obs;
  RxBool isRotating = false.obs;

  Rx<UserModel> driverModel = UserModel().obs;
  Rx<TruckModel> truck = TruckModel().obs;

  @override
  void onInit() {
    truck.value = Get.arguments as TruckModel;
    if (truck.value.driverUuid == null) {
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
    List<UserModel>? driverList = await DriverService.getAllDriver();
    if (driverList != null) {
      arrDriver.clear();
      arrDriver.addAll(driverList);
    }
  }

  Future<int> assignDriver({required UserModel driverInfo}) async {
    if (driverInfo.profile?.driverUuid == null) {
      GlobalService.showAppToast(message: 'Please select driver');
      return 0;
    }
    int assigned = await TruckService.assignDriver(
      vhNumber: truck.value.regdNumber!,
      driver: driverInfo,
    );

    if (assigned > 0) {
      TruckModel? updatedTruck = await TruckService.getTruck(value: truck.value.id!);
      if (updatedTruck != null) {
        truck.value = updatedTruck;
        isDriverAssigned.value = true;
      }
    }
    return assigned;
  }

  Future<int> removeDriver({required TruckModel truckInfo}) async {
    int success = await TruckService.removeDriver(oldTruck: truckInfo);
    if (success > 0) {
      TruckModel? updatedTruck = await TruckService.getTruck(value: truck.value.id!);
      if (updatedTruck != null) {
        truck.value = updatedTruck;
        isDriverAssigned.value = false;
      }
    }
    return success;
  }
}
