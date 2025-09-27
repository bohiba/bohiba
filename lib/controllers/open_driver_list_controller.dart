import '/model/open_driver_model.dart';
import '/services/open_driver_service.dart';
import 'package:get/get.dart';

class OpenDriverListController extends GetxController {
  RxList<OpenDriverModel> arrOpenDriver = <OpenDriverModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      arrOpenDriver.value = await OpenDriverService.getOpenDriver();
    });
  }

  Future<void> expressIntrest({required String driverUuid}) async {
    Map<String, dynamic> bodyObj = {"driver_uuid": driverUuid};
    int expressed = await OpenDriverService.expressInternet(bodyMap: bodyObj);
    if (expressed > 0) {
      // Action
    }
  }
}
