import '/extensions/bohiba_extension.dart';
import '/model/owner_expenses_model.dart';

import '/model/truck_model.dart';
import '/services/truck_service.dart';
import '/services/owner_expense_service.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class AddOwnerExpenseController extends GetxController {
  Rxn<OwnerExpense> ownerExpense = Rxn<OwnerExpense>();
  RxList<TruckModel> arrTruck = <TruckModel>[].obs;
  TextEditingController expensedateController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController expenseTypeController = TextEditingController();
  TextEditingController severityController = TextEditingController();
  TextEditingController descController = TextEditingController();
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
    initialValue: 0.0,
    leftSymbol: '₹',
    thousandSeparator: ',',
    precision: 2,
    decimalSeparator: '.',
  );

  List<String> get arrExpenseType => [
        'engine_repair',
        'tyre_replacement',
        'battery_service',
        'brake_service',
        'oil_change',
        'body_work',
        'insurance',
        'finance_bank',
        'spare_parts',
        'cleaning_wash',
        'documentation',
        'transport_logistics',
        'others',
      ];

  List<String> arrSeverity = [
    "low",
    "medium",
    "high",
  ];

  RxInt countUpdate = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ownerExpense.value = Get.arguments;
    if (ownerExpense.value != null) {
      assignEditValue();
    }
    Future.delayed(Duration.zero, () async {
      await getAllTruck();
    });
  }

  Future<int> addOrUpdateOwnerExpense() async {
    Map<String, dynamic> expenseData = {
      'expense_date': expensedateController.text,
      'truck_regd': vehicleController.text,
      'severity': severityController.text.toLowerCase(),
      'expense_type': expenseTypeController.text.toLowerCase().replaceAll(' ', '_'),
      'amount': amountController.numberValue,
      'description': descController.text
    };

    int sucess = 0;
    if (ownerExpense.value == null) {
      sucess = await OwnerExpenseService.addOwnerExpense(bodyMap: expenseData);
      if (sucess > 0) {
        clearController();
        countUpdate.value++;
      }
      return sucess;
    } else {
      Map<String, dynamic> bodyObj = {
        'expense_date': expensedateController.text,
        'truck_regd': vehicleController.text,
        'severity': severityController.text.toLowerCase(),
        'expense_type': expenseTypeController.text.toLowerCase().replaceAll(' ', '_'),
        'amount': amountController.numberValue,
        'description': descController.text
      };
      sucess = await OwnerExpenseService.updateExpense(
        id: ownerExpense.value?.id,
        bodyMap: bodyObj,
      );

      if (sucess > 0) {
        countUpdate.value++;
      }
      return sucess;
    }
  }

  Future<void> getAllTruck() async {
    List<TruckModel>? truckList = await TruckService.getTruckList();
    if (truckList != null) {
      arrTruck.clear();
      arrTruck.addAll(truckList);
    }
  }

  void assignEditValue() {
    expensedateController.text = ownerExpense.value?.expenseDate ?? '';
    vehicleController.text = ownerExpense.value?.truckRegd ?? '';
    expenseTypeController.text = ownerExpense.value?.expenseType?.toCapitalizedLabel().replaceAll('_', ' ') ?? '';
    severityController.text = ownerExpense.value?.severity?.toCapitalizedLabel() ?? '';
    descController.text = ownerExpense.value?.description ?? '';
    amountController.text = ownerExpense.value?.amount.toString() ?? '';
  }

  void clearController() {
    expensedateController.clear();
    vehicleController.clear();
    expenseTypeController.clear();
    severityController.clear();
    descController.clear();
    amountController.updateValue(0.0);
  }
}
