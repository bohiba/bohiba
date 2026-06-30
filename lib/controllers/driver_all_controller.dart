import '../dist/enums/app_enums.dart';
import '../model/user_model.dart';
import '/services/driver_service.dart';
import '../core/network/dio_serivce.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DriverAllController extends GetxController {
  final RefreshController refreshList = RefreshController();
  DioService dioService = DioService();
  AddAssetUsing addUserBy = AddAssetUsing.doc;

  RxList<UserModel> arrDriver = <UserModel>[].obs;

  RxString strErrorDes = ''.obs;
  RxString strErrorTitle = ''.obs;

  RxBool popResult = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getDriverList();
    });
  }

  Future<List<UserModel>?> getDriverList({
    MethodType type = MethodType.local,
    bool resetList = false,
  }) async {
    List<UserModel>? driverList =
        await DriverService.getAllDriver(methodType: type, reset: resetList);
    if (driverList != null) {
      arrDriver.clear();
      arrDriver.addAll(driverList);
      return driverList;
    } else {
      strErrorTitle.value = 'Driver Not Found';
      strErrorDes.value =
          'Add a driver and assign them driver and start trips quickly';
    }
    return null;
  }
}
