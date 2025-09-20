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

  RxString strDriverUuid = ''.obs;
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

  Future<List<DriverModel>> _getDriverList() async {
    List<DriverModel> driverList = await dBService.getAllData(tblDriver);
    arrDriver.clear();
    arrDriver.addAll(driverList);
    return driverList;
  }

  Future<void> assignDriver({
    required String driverUuid,
    required String regdNumber,
  }) async {
    GlobalService.closeKeyboard();
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'driver_uuid': driverUuid,
    };
    ApiResponse serviceResponse = await dioService
        .post("${ApiEndPoint.apiAssignDriver}/$regdNumber", body: bodyObj);
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 200:
        truck.value = await getTruckInfo(regdNumber: regdNumber);
        isDriverAssigned.value = true;
        break;
      case 401:
        break;

      default:
    }
  }

  Future<void> removeDriver(
      {required String regdNumber, required String id}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse =
        await dioService.post('${ApiEndPoint.apiRemoveDriver}/$regdNumber');
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 200:
        isDriverAssigned.value = false;
        truck.value = await getTruckInfo(regdNumber: regdNumber);
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        break;

      default:
    }
  }

  Future<TruckModel> getTruckInfo({required String regdNumber}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return TruckModel();
    }
    GlobalService.closeKeyboard();
    GlobalService.showProgress();
    ApiResponse response =
        await dioService.get('${ApiEndPoint.apiGetTruck}/$regdNumber');
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
