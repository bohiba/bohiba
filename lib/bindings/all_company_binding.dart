import '../controllers/all_company_controller.dart';
import 'package:get/get.dart';

class AllCompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllCompanyController>(() => AllCompanyController());
  }
}
