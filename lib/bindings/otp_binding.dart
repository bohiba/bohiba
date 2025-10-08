import '/controllers/otp_controller.dart';

import 'package:get/get.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OtpController>(Get.put(OtpController()));
  }
}
