import '/dist/component_exports.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '/routes/app_route.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/input_formatters/aadhar_number_formatter.dart';
import '/component/bohiba_inputfield/input_formatters/dl_formatter.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/controllers/user_profile_config_controller.dart';
import '/theme/bohiba_theme.dart';

class UserDocAuthPage extends GetView<UserProfileConfigController> {
  const UserDocAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    int role = 0;
    Map<String, dynamic> argument = Get.arguments as Map<String, dynamic>;
    role = argument['role_id'];

    bool isTruckOwner = role == 6;
    return Scaffold(
      appBar: TitleAppbar(
        title: '',
      ),
      body: Container(
        height: ScreenUtils.height,
        width: ScreenUtils.width,
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              'Verify Document',
              style: bohibaTheme.textTheme.headlineLarge,
            ),
            Text(
              'Fill identification number\'s to verify your identity.',
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                color: bohibaTheme.textTheme.titleSmall!.color,
              ),
            ),
            TextInputField(
              hintText: 'Aadhar Number',
              maxLength: 19,
              inputFormatters: [
                AadhaarNumberFormatter(),
              ],
              keyboardType: TextInputType.number,
            ),
            TextInputField(
              hintText: 'PAN Number',
              maxLength: 19,
              inputFormatters: [
                AadhaarNumberFormatter(),
              ],
              keyboardType: TextInputType.number,
            ),
            isTruckOwner
                ? Container()
                : TextInputField(
                    hintText: 'DL Number',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9]'),
                      ),
                      DrivingLicenseInputFormatter(),
                    ],
                    textCapitalization: TextCapitalization.characters,
                  ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtils.height47),
              child: PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.navBar,
                      (val) {
                    return false;
                  });
                },
                label: 'Verify',
              ),
            )
          ],
        ),
      ),
    );
  }
}
