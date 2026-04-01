import '../dist/enums/app_enums.dart';
import '/extensions/bohiba_extension.dart';
import '/model/trip_model.dart';
import '/services/global_service.dart';
import '/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

class TripPaymentAddController extends GetxController {
  TripModel? tripModel;
  TripPayment? tripPayment;

  DateTime paymentDate = DateTime.now();
  TextEditingController paymentDateController = TextEditingController();
  TextEditingController paidByController = TextEditingController();
  TextEditingController rcviedController = TextEditingController();
  TextEditingController paymentTypeController = TextEditingController();
  TextEditingController paymentModeController = TextEditingController();

  MoneyMaskedTextController paidController = MoneyMaskedTextController(
    initialValue: 0,
    precision: 2,
    leftSymbol: "₹",
    decimalSeparator: ".",
    thousandSeparator: ",",
  );

  List<String> get arrPaymentMode => ['bank_transfer', 'cash', 'cheque', 'discounted', 'upi'];
  List<String> get arrRecievedBy => ['driver', 'manager', 'self', 'other'];
  List<String> get arrPaymentType => ['Discount', 'Disel Advance', 'Final Settelement', 'Other'];

  RxInt countUpdate = 0.obs;

  @override
  void onInit() {
    if (Get.arguments is TripModel) {
      tripModel = Get.arguments;
    } else {
      tripPayment = Get.arguments;
      editPayment();
    }
    super.onInit();
  }

  Future<void> addUpdatePayment() async {
    Map<String, dynamic> bodyObj = {
      'payer_type': paymentTypeController.text.trim().toLowerCase().replaceAll(' ', '_'),
      'payment_mode': paymentModeController.text.trim().toLowerCase().replaceAll(' ', '_'),
      'amount': (paidController.text.replaceAll(RegExp(r'[₹,]'), '').trim()).toDouble(),
      'paid_by': paidByController.text.trim().toLowerCase().replaceAll(' ', '_'),
      'received_by': rcviedController.text.trim().toLowerCase().replaceAll(' ', '_'),
      'payment_time': paymentDateController.text.trim(),
    };

    if (tripModel == null && tripPayment != null) {
      int editPayment = await TripService.editPayment(
        paymentId: tripPayment!.id!,
        bodyMap: bodyObj,
      );
      if (editPayment > 0) {
        // Get.back();
        countUpdate++;
        Get.back(result: true);
      } else {
        GlobalService.showAppToast(message: 'Failed to update payment');
      }
    } else if (tripModel != null && tripPayment == null) {
      bodyObj['trip_id'] = tripModel!.id;
      int addPayment = await TripService.addPayment(
        bodyMap: bodyObj,
        tripModel: tripModel!,
      );
      if (addPayment > 0) {
        countUpdate++;
        Get.back(result: true);
      } else {
        GlobalService.showAppToast(message: 'Failed to update payment');
      }
    } else {
      // No Operation
    }
    clearController();
  }

  void clearController() {
    paymentDateController.clear();
    paymentTypeController.clear();
    paidByController.clear();
    rcviedController.clear();
    paymentTypeController.clear();
    paymentModeController.clear();
    paidController.updateValue(0.0);
  }

  void editPayment() {
    paymentDateController.text = tripPayment?.paymentTime ?? '';
    paidByController.text = tripPayment?.paidBy ?? '';
    rcviedController.text = tripPayment?.receivedBy ?? '';
    paymentModeController.text = tripPayment?.paymentMode ?? '';
    paymentTypeController.text = tripPayment?.paymentType ?? '';
    paidController = MoneyMaskedTextController(
      initialValue: tripPayment?.amount ?? 0.0,
      precision: 2,
      leftSymbol: "₹",
      decimalSeparator: ".",
      thousandSeparator: ",",
    );
  }

  void disposeController() {
    paymentDateController.dispose();
    paymentTypeController.dispose();
    paidByController.dispose();
    rcviedController.dispose();
    paymentTypeController.dispose();
    paymentModeController.dispose();
    paidController.dispose();
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  onExit() {
    GlobalService.showAlertDialog(
      status: AlertStatus.info,
      title: 'Save Changes?',
      description: 'You have unsaved changes. Do you want to save them before exiting?',
      onSave: () {},
      onDiscard: () {},
    );
  }
}
