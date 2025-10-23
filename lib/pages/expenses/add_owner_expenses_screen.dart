import '/pages/widget/required_label.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/controllers/add_owner_expense_controller.dart';
import '/services/global_service.dart';
import '/component/bohiba_dropdown/primary_dropdown_menu.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/dist/component_exports.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddOwnerExpensesScreen extends GetView<AddOwnerExpenseController> {
  const AddOwnerExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Owner Expense', popResult: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
          ),
          child: Obx(() {
            return Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      PrimaryDropDownMenu(
                        items: controller.arrTruck
                            .map((vehicle) => vehicle.regdNumber!)
                            .toList(),
                        menuController: controller.vehicleController,
                        onChanged: (t1) {
                          controller.truckModel.value = controller.arrTruck
                              .where((vehicle) => vehicle.regdNumber == t1)
                              .toList()
                              .first;
                        },
                        hint: 'Select Your Vehicle',
                      ),
                      PrimaryDropDownMenu(
                        width: ScreenUtils.width,
                        hint: 'Select Service Type',
                        items: controller.arrServiceType,
                        menuController: controller.serviceTypeController,
                      ),
                      RequiredLabel(label: 'Amount', required: true),
                      TextInputField(
                        hintText: 'Amount',
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: controller.amountController,
                      ),
                    ],
                  ),
                ),
                PrimaryButton(
                  padding: EdgeInsets.only(bottom: 15.h),
                  onPressed: () async => controller.addOwnerExpense(),
                  label: 'Add Expense',
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
