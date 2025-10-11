import '/controllers/home_controller.dart';

import '/controllers/truck_all_controller.dart';
import '/controllers/open_driver_list_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<TruckAllController>(TruckAllController());
    // Get.put<DriverAllController>(DriverAllController());
    Get.put<OpenDriverListController>(OpenDriverListController());
  }
}
