import 'package:bohiba/controllers/analytic_conroller.dart';
import 'package:get/get.dart';

class AnalyticBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AnalyticConroller>(AnalyticConroller());
  }
}
