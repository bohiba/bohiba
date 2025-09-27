import '/controllers/trip_expense_add_controller.dart';
import 'package:get/get.dart';

class TripExpenseAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddTripExpenseController>(AddTripExpenseController());
  }
}
