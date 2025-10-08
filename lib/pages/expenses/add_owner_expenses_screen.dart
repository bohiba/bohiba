import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/controllers/auth_controller.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class AddOwnerExpensesScreen extends GetView<AuthController> {
  const AddOwnerExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: "Add Expenses"),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop == true) {
            return;
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.width20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add your expense details here!',
                  style: bohibaTheme.textTheme.displayMedium,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Monitor your spending to optimize vehicle performance and savings.',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                ),
              ),
              Form(
                // key: signupKey,
                child: Column(
                  children: [
                    //Vehicle number input
                    TextInputField(
                      // controller: controller.nameController,
                      hintText: "Vehicle Number",
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      nextActionType: TextInputAction.next,
                      prefixIcon: Icon(
                        Remix.truck_fill,
                      ),
                    ),

                    //Service type input
                    TextInputField(
                      hintText: "Service type",
                      prefixIcon: Icon(Remix.settings_fill),
                      maxLength: 13,
                      keyboardType: TextInputType.text,
                      nextActionType: TextInputAction.done,
                      // controller: controller.mobileController,
                    ),

                    //Expense Date Input
                    DateInputField(
                      width: ScreenUtils.width,
                      hintText: 'Expense Date',
                      // controller: controller.dateController,
                      onTap: () async {},
                    ),

                    TextInputField(
                      hintText: "Amount",
                      prefixIcon: Icon(Remix.money_rupee_circle_fill),
                      maxLength: 13,
                      keyboardType: TextInputType.text,
                      nextActionType: TextInputAction.done,
                      // controller: controller.mobileController,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtils.height10),
              PrimaryButton(
                label: 'Submit',
                onPressed: () async {
                  // if (email != null) {
                  //   await controller.registerUser(txtEmail: email);
                  //   return;
                  // }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
