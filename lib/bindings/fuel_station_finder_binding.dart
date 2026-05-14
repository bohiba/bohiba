import 'package:bohiba/controllers/fuel_station_finder_controller.dart';
import 'package:get/get.dart';

class FuelStationFinderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FuelStationFinderController>(() => FuelStationFinderController());
  }
}
