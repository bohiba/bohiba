import 'package:get/get.dart';

import '../controllers/all_ticket_controller.dart';

class AllTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllTicketController>(() => AllTicketController());
  }
}
