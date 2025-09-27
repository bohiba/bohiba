import 'package:bohiba/model/open_driver_model.dart';
import 'package:get/get.dart';

class OpenDriverController extends GetxController {
  late OpenDriverModel openDriver;

  @override
  void onInit() {
    super.onInit();
    openDriver = Get.arguments;
  }
}
