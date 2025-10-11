import '/controllers/forgot_uuid_controller.dart';
import 'package:get/get.dart';

class ForgotUuidBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ForgotUuidController>(ForgotUuidController());
  }
}
