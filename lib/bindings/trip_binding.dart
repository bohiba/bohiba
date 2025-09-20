import '/controllers/trip_controller.dart';
import 'package:get/get.dart';

class TripBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TripController>(TripController());
  }
}
