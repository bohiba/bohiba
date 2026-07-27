import 'package:get/get.dart';
import '/controllers/owner_company_controller.dart';

class OwnerCompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OwnerCompanyController>(OwnerCompanyController());
  }
}
