import 'package:bohiba/model/truck_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOwnerExpenseController extends GetxController{
  Rx<TruckModel> truckModel = TruckModel().obs;
  RxList<TruckModel> arrTruck = <TruckModel>[].obs;
    TextEditingController expensedateController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController serviceTypeController = TextEditingController();
  TextEditingController amountController = TextEditingController();

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
}