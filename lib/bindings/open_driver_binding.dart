import '../controllers/open_driver_controller.dart';
import 'package:get/get.dart';

class OpenDriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OpenDriverController>(OpenDriverController());
  }
}
