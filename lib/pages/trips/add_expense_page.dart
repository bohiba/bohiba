import '/controllers/trip_expense_add_controller.dart';
import 'package:get/get.dart';
import '/component/bohiba_dropdown/app_dropdown_button.dart';
import '/component/bohiba_dropdown/primary_dropdown_menu.dart';
import '/component/bohiba_buttons/primary_button.dart';
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
    return Scaffold(
      appBar: TitleAppbar(
        title: controller.tripModel == null ? 'Edit Expense' : 'Add Expense',
        popResult: true,
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
                    DateTime expenseDate =
                        await GlobalService.datePickerModal(context: context);
                    controller.expensedateController.text =
                        DateFormat('dd-MM-yyyy').format(expenseDate);
                  },
                  controller: controller.expensedateController,
                  hintText: 'Expense Date',
                ),
                AppDropdown(
                  items: controller.arrExpenseTypes,
                  labelBuilder: (type) => type,
                  onChanged: (p0) {
                    GlobalService.printHandler(p0.toString());
                    // controller.paidToController.text = p0 ?? '';
                    controller.update();
                  },
                  hint: 'Select Expense Type',
                  menuController: controller.typeController,
                ),
                PrimaryDropDownMenu(
                  width: ScreenUtils.width,
                  hint: 'Select Payment Mode',
                  items: controller.arrPaymentMode,
                  menuController: controller.paymentModeController,
                ),
                Text('Expense'),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryButton(
                onPressed: () async => await controller.addExpense(),
                label: controller.tripModel == null ? 'UPDATE' : 'SAVE',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
