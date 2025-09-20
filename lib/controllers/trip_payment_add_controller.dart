import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/extensions/bohiba_extension.dart';
import 'package:bohiba/model/trip_model.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:bohiba/services/trip_service.dart';
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

  List<String> get arrPaymentMode => ['Cash', 'UPI', 'Bank Transfer', 'Cheque'];
  List<String> get arrRecievedBy => ['Driver', 'Manager', 'Self', 'Other'];
  List<String> get arrPaymentType =>
      ['Discount', 'Disel Advance', 'Final Settelement', 'Other'];

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
      'payer_type': paymentTypeController.text.trim(),
      'payment_mode': paymentModeController.text.trim(),
      'amount': (paidController.text.replaceAll(RegExp(r'[₹,]'), '').trim())
          .toDouble(),
      'paid_by': rcviedController.text.trim(),
      'received_by': rcviedController.text.trim(),
      'payment_time': paymentDateController.text.trim(),
    };

    if (tripModel == null && tripPayment != null) {
      int editPayment = await TripService.editPayment(
        paymentId: tripPayment!.id!,
        bodyMap: bodyObj,
      );
      if (editPayment > 0) {
        // Get.back();
        Get.back(result: true);
      } else {
        GlobalService.showAppToast(message: 'Something went wrong');
      }
    } else if (tripModel != null && tripPayment == null) {
      bodyObj['trip_id'] = tripModel!.id;
      int addPayment = await TripService.addPayment(
        bodyMap: bodyObj,
        tripModel: tripModel!,
      );
      if (addPayment > 0) {
        Get.back(result: true);
      } else {
        GlobalService.showAppToast(message: 'Something went wrong');
      }
    } else {
      // No Operation
    }
    clearController();
  }

  void clearController() {
    paymentTypeController.clear();
    paidByController.clear();
    rcviedController.clear();
    paymentTypeController.clear();
    paymentModeController.clear();
  }

  void editPayment() {
    paymentDateController.text = tripPayment?.paymentTime ?? '';
    paidByController.text = tripPayment?.paidBy ?? '';
    rcviedController.text = tripPayment?.receivedBy ?? '';
    paymentModeController.text = tripPayment?.paymentMode ?? '';
    paymentTypeController.text = tripPayment?.payerType ?? '';
    paidController = MoneyMaskedTextController(
      initialValue: tripPayment?.amount ?? 0.0,
      precision: 2,
      leftSymbol: "₹",
      decimalSeparator: ".",
      thousandSeparator: ",",
    );
  }

  onExit() {
    GlobalService.showAlertDialog(
      status: AlertStatus.info,
      title: 'Save Changes?',
      description:
          'You have unsaved changes. Do you want to save them before exiting?',
      onSave: () {},
      onDiscard: () {},
    );
  }
}
