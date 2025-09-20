import '/controllers/master_controller.dart';
import 'package:get/get.dart';

class MasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MasterController>(MasterController());
  }
}
