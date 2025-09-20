import '/services/trip_service.dart';

import '/model/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

class AddTripExpenseController extends GetxController {
  // Expense Controller
  TextEditingController expensedateController = TextEditingController();
  TextEditingController paymentModeController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController expenseRemarkController = TextEditingController();
  MoneyMaskedTextController paidController = MoneyMaskedTextController(
    initialValue: 0,
    precision: 2,
    leftSymbol: "₹",
    decimalSeparator: ".",
    thousandSeparator: ",",
  );

  TripModel? tripModel;
  TripExpense? tripExpense;

  List<String> get arrPaymentMode => ['Cash', 'UPI', 'Bank', 'Cheque'];
  List<String> get arrExpenseTypes => [
        "Advance to Driver",
        "Fuel",
        "FastTag",
        "Loading Charges",
        "Unloading Charges",
        "Driver Allowance / Fooding",
        "Parking Charges",
        "Typre Puncture",
        "Urea",
        "Tyre Replacement",
        "Penalty / Fine",
        "Weighbridge",
        "Mobile Recharge",
        "Other",
      ];

  @override
  void onInit() {
    if (Get.arguments is TripModel) {
      tripModel = Get.arguments as TripModel;
    } else {
      tripExpense = Get.arguments as TripExpense;
      editTextController();
    }
    super.onInit();
  }

  Future<void> addExpense() async {
    Map<String, dynamic> bodyObj = {
      'trip_id': tripModel?.id,
      'truck_regd_number': tripModel?.truck?.regdNumber?.trim(),
      'expense_date': expensedateController.text.trim(),
      'expense_type': typeController.text.trim(),
      'balance_amount': "0.0",
      'payment_mode': paymentModeController.text.trim(),
      'paid': (paidController.text.replaceAll(RegExp(r'[₹,]'), '').trim()),
      'paid_to': '',
      'remarks': '',
    };

    if (tripModel == null && tripExpense != null) {
      int editSucess = await TripService.editExpense(
        expenseId: tripExpense!.id!,
        bodyMap: bodyObj,
      );
      if (editSucess > 0) {
        Get.back(result: true);
      }
    } else if (tripModel != null && tripExpense == null) {
      bodyObj['trip_id'] = tripModel!.id!;
      int expenseAdded = await TripService.addExpense(
        bodyObj: bodyObj,
        trip: tripModel!,
      );
      if (expenseAdded > 0) {
        // Get.back(result: true);
      }
    } else {
      DoNothingAction();
    }
    onDiscard();
  }

  void editTextController() {
    expensedateController.text = tripExpense?.expenseDate ?? '';
    paymentModeController.text = tripExpense?.paymentMode ?? '';
    typeController.text = tripExpense?.expenseType ?? '';
    paidController = MoneyMaskedTextController(
      initialValue: tripExpense?.paid ?? 0.0,
      precision: 2,
      leftSymbol: "₹",
      decimalSeparator: ".",
      thousandSeparator: ",",
    );
  }

  void onDiscard({bool shouldUpdateUI = false}) {
    expensedateController.clear();
    typeController.clear();
    paymentModeController.clear();
    paidController.text = "₹0.0";
    expenseRemarkController.clear();
  }

  @override
  void onClose() {
    onDiscard();
    super.onClose();
  }
}
