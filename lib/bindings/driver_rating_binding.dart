import '/controllers/driver_rating_controller.dart';
import 'package:get/get.dart';

class DriverRatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverRatingController>(() => DriverRatingController());
  }
}
