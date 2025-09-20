import '/controllers/driver_all_controller.dart';
import 'package:get/get.dart';

class DriverAllBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DriverAllController>(DriverAllController());
  }
}
