import '/controllers/set_role_controller.dart';
import 'package:get/get.dart';

class SetRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SetRoleController>(SetRoleController());
  }
}
