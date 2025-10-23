import '../controllers/job_controller.dart';
import 'package:get/get.dart';

class JobDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<JobController>(JobController());
  }
}
