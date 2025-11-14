import '/controllers/owner_expense_controller.dart';
import 'package:get/get.dart';

class OwnerExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerExpenseController>(() => OwnerExpenseController());
  }
}
