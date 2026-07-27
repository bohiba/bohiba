import '../controllers/all_trip_controller.dart';
import 'package:get/get.dart';

class AllTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllTripController>(() => AllTripController(), fenix: true);
  }
}
