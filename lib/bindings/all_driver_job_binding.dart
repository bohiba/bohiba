import '/controllers/all_driver_job_controller.dart';
import 'package:get/get.dart';

class AllDriverJobBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllDriverJobController>(() => AllDriverJobController());
  }
}
