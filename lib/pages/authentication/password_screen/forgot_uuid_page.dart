import 'package:bohiba/component/bohiba_inputfield/email_inputfield.dart';

import '/controllers/forgot_uuid_controller.dart';

import '/extensions/bohiba_extension.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotUuidPage extends GetView<ForgotUuidController> {
  const ForgotUuidPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width20,
        ),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forgot UUID',
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              Text(
                'No worries, Validated below credential and we will mail your UUID.',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                  color: bohibaTheme.textTheme.titleSmall!.color,
                ),
              ),
              EmailInputField(
                hintText: 'Email',
                controller: controller.emailController,
                showIcon: false,
              ),
              TextInputField(
                hintText: 'PAN Number',
                maxLength: 10,
                controller: controller.panController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                nextActionType: TextInputAction.next,
                validateField: (inputValue) {
                  if (inputValue == null || inputValue.isEmpty) {
                    return 'Pan number cannot be empty';
                  } else if (inputValue.length != 10 ||
                      !inputValue.isValidPan) {
                    return 'Please enter valid PAN number';
                  } else {
                    return null;
                  }
                },
              ),
              Obx(
                () => PrimaryButton(
                  onPressed: controller.isButtonEnabled.value
                      ? () async {
                          await controller.forgotUUID().then((onValue) {
                            if (onValue != null && onValue == true) {
                              navigateState.pop();
                            }
                          });
                        }
                      : null,
                  label: 'Verify',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
