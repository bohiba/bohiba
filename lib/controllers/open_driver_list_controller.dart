import '/model/driver_model.dart';
import '/services/open_driver_service.dart';
import 'package:get/get.dart';

class OpenDriverListController extends GetxController {
  RxList<DriverModel> arrOpenDriver = <DriverModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await getAllOpenDriver();
    });
  }

  Future<void> getAllOpenDriver() async {
    List<DriverModel> openDriverList =
        await OpenDriverService.getAllOpenDriver();
    arrOpenDriver.clear();
    arrOpenDriver.addAll(openDriverList);
  }
}
