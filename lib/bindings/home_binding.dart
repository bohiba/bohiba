import '/controllers/home_controller.dart';

import '/controllers/truck_all_controller.dart';
import '/controllers/open_driver_list_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<TruckAllController>(() => TruckAllController(), fenix: true);
    // Get.put<DriverAllController>(DriverAllController());
    Get.lazyPut<OpenDriverListController>(() => OpenDriverListController(),
        fenix: true);
  }
}
