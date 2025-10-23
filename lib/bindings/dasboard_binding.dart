import '/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class DasboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
  }
}
