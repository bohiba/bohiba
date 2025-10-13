import 'package:bohiba/services/owner_expense_service.dart';

import '/services/truck_service.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '/model/truck_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOwnerExpenseController extends GetxController {
  Rx<TruckModel> truckModel = TruckModel().obs;
  RxList<TruckModel> arrTruck = <TruckModel>[].obs;
  TextEditingController expensedateController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController serviceTypeController = TextEditingController();
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
    initialValue: 0.0,
    leftSymbol: '₹',
    thousandSeparator: ',',
    precision: 2,
    decimalSeparator: '.',
  );

  List<String> get arrServiceType => [
        'Engine Repair',
        'Tyre Service',
        'Battery Service',
        'Brake Service',
        'Oil Change',
        'Body Work',
        'Insurance',
        'Finance/Bank',
        'Spare Parts',
        'Cleaning/Wash',
        'Documentation',
        'Transport/Logistics',
        'Others',
      ];

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await getAllTruck();
    });
  }

  Future<void> addOwnerExpense() async {
    if (expensedateController.text.isEmpty ||
        vehicleController.text.isEmpty ||
        serviceTypeController.text.isEmpty ||
        amountController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all the fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

debugPrint("Truck Model ID: ${truckModel.value.id}");
    Map<String, dynamic> expenseData = {
      'expense_date': expensedateController.text,
      'truck_regd': truckModel.value.regdNumber,
      'expense_type': serviceTypeController.text,
      'amount': amountController.numberValue,
    };

    try {
      
        int addSucess = await OwnerExpenseService.addOwnerExpense(
            bodyMap: expenseData, truckModel: truckModel.value);
            debugPrint('Add Owner Expense Success: $addSucess');
        if (addSucess > 0) {
            // On success
      Get.snackbar(
        'Success',
        'Owner expense added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
          Get.back(result: true);
        
      }

      // // On success
      // Get.snackbar(
      //   'Success',
      //   'Owner expense added successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );

      // Clear the form
      expensedateController.clear();
      vehicleController.clear();
      serviceTypeController.clear();
      amountController.updateValue(0.0);
    } catch (e) {
      // On error
      Get.snackbar(
        'Error',
        'Failed to add owner expense',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> getAllTruck() async {
    List<TruckModel> truckList = await TruckService.retriveAllTruck();
    arrTruck.clear();
    arrTruck.addAll(truckList);
  }
}
