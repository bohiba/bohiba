
import 'package:bohiba/component/bohiba_dropdown/app_dropdown_button.dart';
import 'package:bohiba/component/bohiba_dropdown/primary_dropdown_menu.dart';
import 'package:bohiba/controllers/add_owner_expense_controller.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:intl/intl.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/dist/component_exports.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


 class AddOwnerExpensesScreen extends GetView<AddOwnerExpenseController> {
  const AddOwnerExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Owner Expense',
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
                    DateTime? expenseDate =
                        await GlobalService.datePickerModal(context: context);
                    if (expenseDate != null) {
                      controller.expensedateController.text =
                          DateFormat('dd-MM-yyyy').format(expenseDate);
                    }
                  },
                  controller: controller.expensedateController,
                  hintText: 'Expense Date',
                ),
                AppDropdown(
                   items: controller.arrTruck.value,
                      labelBuilder: (truck) => truck.regdNumber!,
                      menuController: controller.vehicleController,
                      onChanged: (t1) {
                        controller.truckModel.value = t1!;
                      },
                  hint: 'Select Your Vehicle',
                  
                ),
                PrimaryDropDownMenu(
                  width: ScreenUtils.width,
                  hint: 'Select Service Type',
                  items: controller.arrServiceType,
                  menuController: controller.serviceTypeController,
                ),
                Text('Amount'),
                TextInputField(
                  hintText: 'Amount',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: controller.amountController,
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
                onPressed: () async =>{},
                label: 'Add Expense',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
