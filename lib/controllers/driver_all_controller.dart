import '/dist/app_enums.dart';
import '/model/driver_model.dart';
import '/services/driver_service.dart';
import '/services/dio_serivce.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DriverAllController extends GetxController {
  final RefreshController refreshList = RefreshController();
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

  Future<int> deleteDriver({required int id}) async {
    int success = await DriverService.deleteDriver(driverId: id);
    if (success > 0) {
      // Success
    }
    return success;
  }

  Future<List<DriverModel>?> getDriverList({
    MethodType type = MethodType.local,
    bool resetList = false,
  }) async {
    List<DriverModel>? driverList =
        await DriverService.getAllDriver(methodType: type, reset: resetList);
    if (driverList != null) {
      arrDriver.clear();
      arrDriver.addAll(driverList);
      return driverList;
    }
    return null;
  }
}
