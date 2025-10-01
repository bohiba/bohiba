import '/controllers/trip_all_controller.dart';
import '/controllers/truck_all_controller.dart';
import '/controllers/home_controller.dart';
import '/controllers/dashboard_controller.dart';
import '/controllers/master_controller.dart';
import 'package:get/get.dart';

class NavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MasterController>(MasterController());
    Get.put<HomeController>(HomeController());
    // Get.put<MinesController>(MinesController());
    Get.put<DashboardController>(DashboardController());
    // Get.lazyPut<OpenDriverListController>(() => OpenDriverListController());
    Get.put<AllTripController>(AllTripController());
    Get.put<TruckAllController>(TruckAllController());
  }
}
