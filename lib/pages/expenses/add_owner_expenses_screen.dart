import '/component/bohiba_dropdown/app_dropdown_button.dart';
import '/extensions/bohiba_extension.dart';

import '/dist/component_exports.dart';
import '/services/global_service.dart';
import '/pages/widget/required_label.dart';
import '/controllers/add_owner_expense_controller.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AddOwnerExpensesScreen extends GetView<AddOwnerExpenseController> {
  const AddOwnerExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
            title: 'Owner Expense',
            popResult: controller.countUpdate > 0 ? true : false),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.height20,
                left: ScreenUtils.height15,
                right: ScreenUtils.height15,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RequiredLabel(label: 'Date', required: true),
                  DateInputField(
                    width: ScreenUtils.width,
                    onTap: () async {
                      DateTime? expenseDate =
                          await GlobalService.datePickerModal(
                        context: context,
                      );
                      if (expenseDate != null) {
                        controller.expensedateController.text = DateFormat(
                          'dd-MM-yyyy',
                        ).format(expenseDate);
                      }
                    },
                    controller: controller.expensedateController,
                    hintText: 'Expense Date',
                  ),
                  AppDropdown<String>(
                    items: controller.arrTruck
                        .map((vehicle) => vehicle.regdNumber!)
                        .toList(),
                    menuController: controller.vehicleController,
                    hint: 'Select Your Vehicle',
                    labelBuilder: (String p1) => p1,
                  ),
                  RequiredLabel(label: 'Critical', required: true),
                  AppDropdown<String>(
                    hint: 'Select Service Type',
                    items: controller.arrSeverity,
                    menuController: controller.severityController,
                    labelBuilder: (String p1) =>
                        p1.replaceAll('_', ' ').toCapitalizedLabel(),
                  ),
                  RequiredLabel(label: 'Amount', required: true),
                  TextInputField(
                    hintText: 'Amount',
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: controller.amountController,
                  ),
                  RequiredLabel(label: 'Service Type', required: true),
                  AppDropdown<String>(
                    hint: 'Tyre Replacement',
                    enableSearch: true,
                    requestFocusOnTap: true,
                    items: controller.arrExpenseType,
                    menuController: controller.expenseTypeController,
                    labelBuilder: (String p1) =>
                        p1.replaceAll('_', ' ').toCapitalizedLabel(),
                  ),
                  RequiredLabel(label: 'Description'),
                  TextInputField(
                    maxLines: 6,
                    controller: controller.descController,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    nextActionType: TextInputAction.newline,
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
              onPressed: () async => controller.addOrUpdateOwnerExpense(),
              label: 'Add Expense',
            ),
          ),
        ),
      );
    });
  }
}
