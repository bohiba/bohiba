import '/controllers/user_profile_config_controller.dart';
import 'package:get/get.dart';

class UserProfileConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserProfileConfigController>(
      UserProfileConfigController(),
      permanent: true,
    );
  }
}
