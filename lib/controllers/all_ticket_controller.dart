import 'package:get/get.dart';

import '/model/ticket_model.dart';
import '/services/ticket_service.dart';

class AllTicketController extends GetxController {
  final RxList<TicketModel> tickets = <TicketModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    isLoading.value = true;
    errorMessage.value = '';
    final List<TicketModel>? result = await TicketService.getAllTickets();
    isLoading.value = false;

    if (result != null) {
      tickets.assignAll(result);
    } else {
      errorMessage.value =
          'Unable to load tickets. Check your connection and try again.';
    }
  }

  @override
  void onClose() {
    tickets.close();
    super.onClose();
  }
}
