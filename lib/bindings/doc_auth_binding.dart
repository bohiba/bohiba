import '/controllers/user_doc_auth_controller.dart';
import 'package:get/get.dart';

class DocAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserDocAuthController>(UserDocAuthController());
  }
}
