import '/controllers/all_recieved_request_controller.dart';
import 'package:get/get.dart';

class AllRecivedRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllRecievedRequestController>(
        () => AllRecievedRequestController());
  }
}
