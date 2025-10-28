import '/routes/app_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/extensions/bohiba_extension.dart';
import '/controllers/user_doc_auth_controller.dart';
import '/dist/app_enums.dart';
import '/services/global_service.dart';

import '/dist/component_exports.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/input_formatters/aadhar_number_formatter.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/theme/bohiba_theme.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UserDocAuthPage extends GetView<UserDocAuthController> {
  const UserDocAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          } else {
            GlobalService.showAlertDialog(
              status: AlertStatus.failure,
              title: 'Verification',
              description:
                  'Are your sure? You want to discontinue you verification process',
              discardBtnTxt: 'No',
              saveBtnTxt: 'Yes',
              onSave: () {
                navigateState.pop();
                navigateState.pop(true);
              },
            );
          }
        },
        child: SafeArea(
          child: Container(
            height: ScreenUtils.height,
            width: ScreenUtils.width,
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.width20,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: controller.verifyDocFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verify Document',
                          style: bohibaTheme.textTheme.headlineLarge,
                        ),
                        Text(
                          'Fill identification number`s to verify your identity.',
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.bodySmall!.fontWeight,
                            color: bohibaTheme.textTheme.titleSmall!.color,
                          ),
                        ),
                        TextInputField(
                          hintText: 'Aadhar Number',
                          maxLength: 14,
                          inputFormatters: [AadhaarNumberFormatter()],
                          keyboardType: TextInputType.number,
                          nextActionType: TextInputAction.next,
                          controller: controller.aadharNumberController,
                          validateField: (inputValue) {
                            if (inputValue == null || inputValue.isEmpty) {
                              return 'Aadhar number cannot be empty';
                            } else if (inputValue.length != 14 ||
                                !inputValue.isValidAadhaar) {
                              return 'Please enter valid Aadhar number';
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextInputField(
                          hintText: 'PAN Number',
                          maxLength: 10,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          controller: controller.panNumberController,
                          nextActionType: controller.isTruckOwner
                              ? TextInputAction.done
                              : TextInputAction.next,
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
                        if (controller.isTruckOwner)
                          SizedBox.shrink()
                        else
                          TextInputField(
                            hintText: 'DL Number',
                            maxLength: 15,
                            textCapitalization: TextCapitalization.characters,
                            controller: controller.dlNumberController,
                            validateField: (inputValue) {
                              if (inputValue == null || inputValue.isEmpty) {
                                return 'DL number cannot be empty';
                              } else if (inputValue.length != 15 ||
                                  !inputValue.isValidDL) {
                                return 'Please enter valid DL number';
                              } else {
                                return null;
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                PrimaryButton(
                  padding: EdgeInsets.only(bottom: 15.h),
                  onPressed: () async {
                    int verifiedDoc = await controller.validateUserDoc();
                    if (verifiedDoc > 0) {
                      navigateState.pushNamedAndRemoveUntil(
                        AppRoute.signIn,
                        ModalRoute.withName(AppRoute.signIn),
                      );
                    }
                  },
                  label: 'Verify',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
