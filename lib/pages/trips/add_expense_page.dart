import '/component/bohiba_buttons/primary_button.dart';
import '/extensions/bohiba_extension.dart';
import '/pages/widget/required_label.dart';

import '/controllers/trip_expense_add_controller.dart';
import 'package:get/get.dart';
import '/component/bohiba_dropdown/app_dropdown_button.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/services/global_service.dart';
import '/dist/component_exports.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends GetView<AddTripExpenseController> {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: controller.tripModel == null ? 'Edit Expense' : 'Add Expense',
          popResult: controller.countUpdate.value > 0 ? true : false,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height20,
              left: ScreenUtils.height15,
              right: ScreenUtils.height15,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateInputField(
                    width: ScreenUtils.width,
                    onTap: () async {
                      DateTime? expenseDate = await GlobalService.datePickerModal(
                          context: context, startTime: DateFormat('dd-MM-yyyy').parse(controller.tripModel?.startDate ?? ''), endTime: DateFormat('dd-MM-yyyy').parse(controller.tripModel?.endedDate ?? ''));
                      if (expenseDate != null) {
                        controller.expensedateController.text = DateFormat('dd-MM-yyyy').format(expenseDate);
                      }
                    },
                    controller: controller.expensedateController,
                    hintText: 'Expense Date',
                  ),
                  AppDropdown(
                    menuHeight: ScreenUtils.height * 0.5,
                    items: controller.arrExpenseTypes,
                    labelBuilder: (type) => type.toCapitalizedLabel(),
                    onChanged: (p0) {
                      GlobalService.printHandler(p0.toString());
                      // controller.update();
                    },
                    hint: 'Select Expense Type',
                    menuController: controller.typeController,
                  ),
                  AppDropdown(
                    hint: 'Select Payment Mode',
                    items: controller.arrPaymentMode,
                    labelBuilder: (mode) => mode.toUpperCase(),
                    menuController: controller.paymentModeController,
                  ),
                  RequiredLabel(label: 'Expense', required: true),
                  TextInputField(
                    hintText: 'Amount',
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: controller.paidController,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: ScreenUtils.height15,
              right: ScreenUtils.height15,
            ),
            child: PrimaryButton(
              onPressed: () async => controller.addExpense(),
              label: "Add expense",
            ),
          ),
        ),
      );
    });
  }
}
