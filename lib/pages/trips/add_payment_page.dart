import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';
import 'package:bohiba/controllers/trip_payment_add_controller.dart';
import 'package:get/get.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_dropdown/primary_dropdown_menu.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/services/global_service.dart';
import 'package:intl/intl.dart';
import '/component/screen_utils.dart';
import 'package:flutter/material.dart';

class AddPaymentPage extends GetView<TripPaymentAddController> {
  const AddPaymentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        controller.onExit();
      },
      child: Scaffold(
        appBar: TitleAppbar(
          title: controller.tripModel == null ? 'Edit Payment' : 'Add Payment',
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: ScreenUtils.height20,
                    left: ScreenUtils.width15,
                    right: ScreenUtils.width15,
                  ),
                  child: Column(
                    children: [
                      DateInputField(
                        width: ScreenUtils.width,
                        onTap: () async {
                          DateTime paymentDate =
                              await GlobalService.datePickerModal(
                                  context: context);
                          controller.paymentDateController.text =
                              DateFormat('dd-MM-yyyy').format(paymentDate);
                        },
                        controller: controller.paymentDateController,
                        hintText: 'Payment Date',
                      ),
                      TextInputField(
                        controller: controller.paidByController,
                        hintText: 'Paid by (Transporter/Mines)',
                        textCapitalization: TextCapitalization.characters,
                        nextActionType: TextInputAction.next,
                      ),
                      PrimaryDropDownMenu(
                        width: ScreenUtils.width,
                        hint: 'Recieved by (Manager/Driver/Self)',
                        items: controller.arrRecievedBy,
                        menuController: controller.rcviedController,
                      ),
                      PrimaryDropDownMenu(
                        width: ScreenUtils.width,
                        hint: 'Select Payment Mode',
                        items: controller.arrPaymentMode,
                        menuController: controller.paymentModeController,
                      ),
                      PrimaryDropDownMenu(
                        width: ScreenUtils.width,
                        hint: 'Select Payment Mode',
                        items: controller.arrPaymentType,
                        menuController: controller.paymentTypeController,
                      ),
                      TextInputField(
                        width: ScreenUtils.width,
                        hintText: 'Amount',
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: controller.paidController,
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                onPressed: () async => await controller.addUpdatePayment(),
                label: controller.tripModel == null ? 'UPDATE' : 'SAVE',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
