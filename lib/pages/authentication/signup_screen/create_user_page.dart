import '/component/bohiba_inputfield/date_inputfield.dart';
import '/controllers/auth_controller.dart';
import '/services/global_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '/component/bohiba_inputfield/password_inputfield.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';

class CreateUserPage extends GetView<AuthController> {
  const CreateUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? email;
    var route = Get.arguments;
    if (route == null) {
    } else {
      final Map<String, dynamic> argsObj = route as Map<String, dynamic>;
      email = argsObj['email'];
    }
    return Scaffold(
      appBar: null,
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
                  'Join Now!',
                  style: bohibaTheme.textTheme.displayMedium,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Start enjoying our features early, Connect with thousands of other users, and Get notified of new features and updates.',
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
                    TextInputField(
                      controller: controller.nameController,
                      hintText: "Full Name",
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      nextActionType: TextInputAction.next,
                      prefixIcon: Icon(
                        Icons.person_rounded,
                      ),
                    ),
                    TextInputField(
                      hintText: "Mobile Numnber",
                      prefixIcon: Icon(Remix.phone_fill),
                      maxLength: 13,
                      keyboardType: TextInputType.phone,
                      nextActionType: TextInputAction.done,
                      controller: controller.mobileController,
                    ),
                    DateInputField(
                      width: ScreenUtils.width,
                      hintText: 'Choose your DOB',
                      controller: controller.dateController,
                      onTap: () async {
                        controller.pickedDate =
                            await GlobalService.datePickerModal(
                          context: context,
                          endYear: DateTime(DateTime.now().year - 18,
                              DateTime.now().month, DateTime.now().day),
                        );
                        controller.dateController.text =
                            DateFormat('dd-MM-yyyy')
                                .format(controller.pickedDate);
                      },
                    ),
                    PasswordInputField(
                      hintText: 'Password',
                      controller: controller.vPwdController,
                      nextActionType: TextInputAction.next,
                    ),
                    PasswordInputField(
                      hintText: 'Confirm Password',
                      controller: controller.vCnfrmController,
                      nextActionType: TextInputAction.done,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtils.height10),
              PrimaryButton(
                label: 'Submit',
                onPressed: () async {
                  if (email != null) {
                    await controller.registerUser(txtEmail: email);
                    return;
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
