import 'package:bohiba/controllers/trip_payment_controller.dart';
import 'package:get/get.dart';

class TripPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TripPaymentController>(TripPaymentController());
  }
}
