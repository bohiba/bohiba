import '/controllers/user_scan_qr_controller.dart';
import 'package:get/get.dart';

class UserScanQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserScanQrController>(() => UserScanQrController());
  }
}
