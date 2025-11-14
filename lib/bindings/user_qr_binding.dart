import 'package:bohiba/controllers/user_qr_controller.dart';
import 'package:get/get.dart';

class UserQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserQrController>(() => UserQrController());
  }
}
