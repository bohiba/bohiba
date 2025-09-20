import 'package:bohiba/controllers/trip_add_reassign_controller.dart';
import 'package:get/get.dart';

class TripAddReassignBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TripAddReassignController>(TripAddReassignController());
  }
}
