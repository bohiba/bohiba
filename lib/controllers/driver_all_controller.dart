import '/services/api_end_point.dart';
import '/dist/app_enums.dart';
import '/model/driver_model.dart';
import '/services/db_service.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';
import 'package:get/get.dart';

class DriverAllController extends GetxController {
  DBService dBService = DBService();
  DioService dioService = DioService();
  AddAssetUsing addUserBy = AddAssetUsing.doc;

  RxList<DriverModel> arrDriver = <DriverModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getDriverList();
    });
  }

  Future<void> deleteDriver({required String id}) async {
    if (!await DeviceInfoService.hasInternet()) return;
    GlobalService.showProgress();
    ApiResponse response =
        await dioService.delete("${ApiEndPoint.apiDeleteDriver}/$id");
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        int dBSuccess = await dBService.deleteData<DriverModel>(tblDriver, id);
        if (dBSuccess > 0) {
          GlobalService.showAppToast(message: response.message);
          Get.back();
          Get.back(result: true);
        }
        break;
      case 401:
        GlobalService.showAppToast(message: response.message);
        break;
      default:
    }
  }

  Future<List<DriverModel>> getDriverList() async {
    List<DriverModel> driverList = await dBService.getAllData(tblDriver);
    arrDriver.clear();
    arrDriver.addAll(driverList);
    return driverList;
  }
}
