import '/controllers/all_applied_job_controller.dart';
import 'package:get/get.dart';

class AllAppliedJobBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AllAppliedJobController>(AllAppliedJobController());
  }
}
