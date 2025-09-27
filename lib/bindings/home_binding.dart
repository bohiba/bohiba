import '../controllers/open_driver_list_controller.dart';

import '/controllers/driver_all_controller.dart';
import '/controllers/home_controller.dart';
import '/controllers/truck_all_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.lazyPut<TruckAllController>(() => TruckAllController());
    Get.lazyPut<DriverAllController>(() => DriverAllController());
    Get.lazyPut<OpenDriverListController>(() => OpenDriverListController());
  }
}
