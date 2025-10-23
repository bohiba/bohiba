import '../controllers/truck_all_controller.dart';
import 'package:get/get.dart';

class TruckAllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TruckAllController>(() => TruckAllController(), fenix: true);
    // Get.put<TripController>(TripController());
  }
}
