import '/controllers/update_contact_info_controller.dart';
import 'package:get/get.dart';

class UpdateContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UpdateContactInfoController>(UpdateContactInfoController());
  }
}
