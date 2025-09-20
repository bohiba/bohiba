import '/controllers/trip_payment_add_controller.dart';
import 'package:get/get.dart';

class AddTripPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TripPaymentAddController>(TripPaymentAddController());
  }
}
