import '/controllers/add_job_controller.dart';
import 'package:get/get.dart';

class AddJobBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddJobController>(AddJobController());
  }
}
