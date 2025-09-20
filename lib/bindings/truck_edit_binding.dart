import '/controllers/truck_edit_controller.dart';
import 'package:get/get.dart';

class TruckEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EditTruckController>(EditTruckController());
  }
}
