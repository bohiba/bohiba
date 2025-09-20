import '/controllers/driver_controller.dart';
import 'package:get/get.dart';

class DriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DriverController>(DriverController());
  }
}
