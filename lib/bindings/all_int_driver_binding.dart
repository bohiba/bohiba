import 'package:bohiba/controllers/all_int_driver_controller.dart';
import 'package:get/get.dart';

class AllIntDriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllIntDriverController>(() => AllIntDriverController());
  }
}
