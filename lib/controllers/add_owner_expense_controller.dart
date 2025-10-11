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

  Future<void> getAllTruck() async {
    List<TruckModel> truckList = await TruckService.retriveAllTruck();
    arrTruck.clear();
    arrTruck.addAll(truckList);
  }
}
