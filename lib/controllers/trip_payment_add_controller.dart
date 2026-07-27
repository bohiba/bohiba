import '../dist/enums/app_enums.dart';
import '../dist/enums/enum_trip_payment.dart';
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

  MoneyMaskedTextController paidController = MoneyMaskedTextController(
    initialValue: 0,
    precision: 2,
    leftSymbol: "₹",
    decimalSeparator: ".",
    thousandSeparator: ",",
  );

  Rxn<EnumTripPaymentReceiver> selectedReceivedBy = Rxn();
  Rxn<EnumTripPaymentMode> selectedPaymentMode = Rxn();
  Rxn<EnumTripPaymentType> selectedPaymentType = Rxn();

  List<EnumTripPaymentReceiver> get arrRecievedBy =>
      EnumTripPaymentReceiver.values;
  List<EnumTripPaymentMode> get arrPaymentMode => EnumTripPaymentMode.values;
  List<EnumTripPaymentType> get arrPaymentType => EnumTripPaymentType.values;

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
      'payment_time': (paymentDateController.text.trim()).toYMD(),
      'paid_by': paidByController.text.trim(),
      'received_by': selectedReceivedBy.value?.index,
      'payment_mode': selectedPaymentMode.value?.index,
      'payment_type': selectedPaymentType.value?.index,
      'amount': (paidController.text.replaceAll(RegExp(r'[₹,]'), '').trim())
          .toDouble(),
    };
    if (tripModel == null && tripPayment != null) {
      int editPayment = await TripService.editPayment(
        paymentId: tripPayment!.id!,
        bodyMap: bodyObj,
      );
      if (editPayment > 0) {
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
    paidByController.clear();
    selectedReceivedBy.value = null;
    selectedPaymentMode.value = null;
    selectedPaymentType.value = null;
    paidController.updateValue(0.0);
  }

  void editPayment() {
    paymentDateController.text = tripPayment?.paymentTime ?? '';
    paidByController.text = tripPayment?.paidBy ?? '';
    selectedReceivedBy.value =
        EnumTripPaymentReceiverExt.fromIndex(tripPayment?.receivedBy);
    selectedPaymentMode.value =
        EnumTripPaymentModeExt.fromIndex(tripPayment?.paymentMode);
    selectedPaymentType.value =
        EnumTripPaymentTypeExt.fromIndex(tripPayment?.paymentType);
    paidController = MoneyMaskedTextController(
      initialValue: tripPayment?.amount ?? 0.0,
      precision: 2,
      leftSymbol: "₹",
      decimalSeparator: ".",
      thousandSeparator: ",",
    );
  }

  @override
  void onClose() {
    paymentDateController.dispose();
    paidByController.dispose();
    paidController.dispose();
    super.onClose();
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
