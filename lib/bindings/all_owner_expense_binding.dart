import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/all_owner_expense_controller.dart';

class AllOwnerExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllOwnerExpenseController>(() => AllOwnerExpenseController(), fenix: true);
    // Get.put<TripController>(TripController());
  }
}