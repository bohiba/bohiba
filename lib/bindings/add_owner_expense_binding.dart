import '/controllers/add_owner_expense_controller.dart';

import 'package:get/get.dart';

class AddOwnerExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddOwnerExpenseController>(AddOwnerExpenseController());
  }
}
