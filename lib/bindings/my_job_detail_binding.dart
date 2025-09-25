import '/controllers/my_job_controller.dart';
import 'package:get/get.dart';

class MyJobDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MyJobController>(MyJobController());
  }
}
