import 'package:bohiba/controllers/all_sent_connection_controller.dart';
import 'package:get/get.dart';

class AllSentRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AllSentRequestController>(AllSentRequestController());
  }
}
