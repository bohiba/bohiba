import '/services/api_end_point.dart';

import '/dist/app_enums.dart';

import '/controllers/master_controller.dart';
import '/services/device_info_service.dart';
import '/model/truck_model.dart';
import '/services/db_service.dart';
import '/services/dio_serivce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '/services/global_service.dart';

class TruckAllController extends GetxController {
  final MasterController masterController = Get.find<MasterController>();
  DioService dioService = DioService();
  DBService dBService = DBService();

  final RefreshController refreshList =
      RefreshController(initialRefresh: false);

  final TextEditingController vehicleNumberController = TextEditingController();

  Rx<AddAssetUsing> addAsset = AddAssetUsing.scan.obs;

  // Driver Details
  RxList<TruckModel> arrTruck = <TruckModel>[].obs;

  RxBool isFav = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getTruckList();
    });
  }

  Future<void> onRefreshTruckList() async {
    await getTruckList();
    refreshList.refreshCompleted();
  }

  Future<void> deleteTruck({required int truckId}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse =
        await dioService.delete("${ApiEndPoint.apiDeleteTruck}/$truckId");
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 200:
        await masterController.profileApi();
        int dBSuccess =
            await dBService.deleteData<TruckModel>(tblTrucks, '$truckId');
        if (dBSuccess > 0) {
          GlobalService.showAppToast(message: serviceResponse.message);
          Get.back(result: true);
        }
        break;
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        break;
      default:
    }
  }

  Future<List<TruckModel>> getTruckList() async {
    arrTruck.clear();
    List<TruckModel> truckList = await dBService.getAllData(tblTrucks);
    arrTruck.addAll(truckList);
    return truckList;
  }

  Future<void> createVehicle({required String vehicleNumber}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {'registration_number': vehicleNumber};
    ApiResponse serviceResponse = await dioService.post(
      ApiEndPoint.apiAddTruck,
      body: bodyObj,
    );
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        break;

      case 201:
        // await masterController.profileApi();
        TruckModel truckModel = TruckModel.fromJson(serviceResponse.data);
        int dBSucess = await dBService.putData<TruckModel>(
            tblTrucks, "${truckModel.id}", truckModel);
        vehicleNumberController.clear();
        if (dBSucess > 0) {
          Get.back(result: true);
        }
      default:
    }
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
