import '/controllers/driver_add_controller.dart';
import 'package:get/get.dart';

class DriverAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverAddController>(() => DriverAddController());
  }
}
