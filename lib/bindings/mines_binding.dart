import '/controllers/mines_controller.dart';
import 'package:get/get.dart';

class MinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MinesController>(MinesController());
  }
}
