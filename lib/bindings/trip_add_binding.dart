import '/controllers/trip_add_controller.dart';
import 'package:get/get.dart';

class TripAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TripAddController>(TripAddController());
  }
}
