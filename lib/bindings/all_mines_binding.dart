import '/controllers/all_mines_controller.dart';
import 'package:get/get.dart';

class AllMinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AllMinesController>(AllMinesController());
  }
}
