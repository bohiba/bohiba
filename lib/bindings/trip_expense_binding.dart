import '/controllers/trip_expense_controller.dart';

import 'package:get/get.dart';

class TripExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TripExpenseController>(TripExpenseController());
  }
}
