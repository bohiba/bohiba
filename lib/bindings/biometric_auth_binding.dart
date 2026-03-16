import '/controllers/biometric_auth_controller.dart';
import 'package:get/get.dart';

class BiometricAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiometricAuthController>(() => BiometricAuthController());
  }
}
