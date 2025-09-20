
import '/controllers/auth_controller.dart';
import '/controllers/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SplashController>(SplashController());
  }
}
