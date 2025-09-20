import 'package:bohiba/controllers/reassignment_controller.dart';
import 'package:get/get.dart';

class ReassignmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ReassignmentController>(ReassignmentController());
  }
}
