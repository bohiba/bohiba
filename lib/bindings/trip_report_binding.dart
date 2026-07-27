import 'package:get/get.dart';
import '/controllers/trip_report_controller.dart';

class TripReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TripReportController>(TripReportController());
  }
}
