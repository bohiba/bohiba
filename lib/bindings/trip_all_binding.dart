import '/controllers/trip_all_controller.dart';
import 'package:get/get.dart';

class AllTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AllTripController>(AllTripController());
  }
}
