import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../model/ticket_model.dart';
import '../services/ticket_service.dart';

class TicketController extends GetxController {
  final RxList<TicketModel> tickets = <TicketModel>[].obs;
  String? selectedIssue;
  final TextEditingController descriptionController = TextEditingController();
  final List<String> bohibaIssues = [
    "Login / Authentication Issue",
    "Trip Creation Problem",
    "Expense Entry Error",
    "Payment Not Reflecting",
    "Driver Assignment Issue",
    "Truck Details Missing/Wrong",
    "App Crashes / Not Responding",
    "Slow Performance",
    "Notification Not Received",
    "Document Upload Failure",
    "Data Sync Problem",
    "Dark Mode / Theme Issue",
    "Incorrect Analytics Report",
    "Profile Update Not Saving",
    "Other (Please Specify)"
  ];

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> createTicket() async {
    isLoading.value = true;
    errorMessage.value = '';
    Map<String, dynamic> data = {
      "title": selectedIssue,
      "description": descriptionController.text,
    };
    final bool result = await TicketService.createTicket(ticketData: data);
    isLoading.value = false;
    if (result == true) {
      descriptionController.clear();
      selectedIssue = null;

      return true;
    } else {
      errorMessage.value =
          'Unable to create ticket. Check your connection and try again.';
      return false;
    }
  }

  @override
  void onClose() {
    tickets.close();
    super.onClose();
  }
}
