import '/model/open_driver_model.dart';
import '/services/open_driver_service.dart';
import 'package:get/get.dart';

class OpenDriverController extends GetxController {
  RxList<OpenDriverModel> arrOpenDriver = <OpenDriverModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      arrOpenDriver.value = await OpenDriverService.localFavList();
    });
  }
}
