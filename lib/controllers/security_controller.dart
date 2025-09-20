import '/controllers/auth_controller.dart';
import 'package:get/get.dart';

class SecurityController extends GetxController {
  final AuthController _authController =
      Get.put<AuthController>(AuthController());

  Future<void> logOut() async {
    await _authController.logout();
  }
}
