import '/controllers/truck_controller.dart';
import 'package:get/get.dart';

class TruckBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TruckController>(TruckController());
  }
}
