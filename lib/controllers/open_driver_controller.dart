import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/model/driver_model.dart';

import '/services/open_driver_service.dart';

import 'package:get/get.dart';

class OpenDriverController extends GetxController {
  Rx<DriverModel> openDriver = DriverModel().obs;

  @override
  void onInit() {
    openDriver.value = Get.arguments;
    super.onInit();

    Future.delayed(Duration.zero, () async {
      if (openDriver.value.licenseDetail == null) {
        await getOpenDriver(
            id: openDriver.value.id!, methodType: MethodType.api);
      } else {
        await getOpenDriver(
          id: openDriver.value.id!,
          methodType: MethodType.local,
        );
      }
    });
  }

  Future<void> connect({required String driverUuid}) async {
    if (openDriver.value.profile?.connect != null) return;
    Map<String, dynamic> bodyObj = {"driver_uuid": driverUuid};
    int expressed = await OpenDriverService.connectDriver(bodyMap: bodyObj);
    if (expressed > 0) {
      // Action
    }
  }

  Future<void> getOpenDriver(
      {required int id, required MethodType methodType}) async {
    DriverModel? driverInfo = await OpenDriverService.getOpenDriverPrfl(
        driverId: id, type: methodType);
    if (driverInfo != null) {
      openDriver.value = driverInfo;
    }
  }
}
