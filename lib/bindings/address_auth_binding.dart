import '/controllers/address_auth_controller.dart';
import 'package:get/get.dart';

class AddressAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddressAuthController>(AddressAuthController());
  }
}
