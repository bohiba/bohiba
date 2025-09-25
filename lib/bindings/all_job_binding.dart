import '/controllers/all_job_controller.dart';
import 'package:get/get.dart';

class AllJobBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllJobController());
  }
}
