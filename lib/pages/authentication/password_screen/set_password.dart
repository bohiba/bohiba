import '/dist/controller_exports.dart';
import 'package:flutter/material.dart';

import '/component/bohiba_inputfield/password_inputfield.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/dist/component_exports.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class ResetSetPasswordPage extends StatelessWidget {
  const ResetSetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController cnfrmPwdController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    return Scaffold(
      appBar: null,
      body: Container(
        height: ScreenUtils.height,
        width: ScreenUtils.width,
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
                'Set Password',
                style: bohibaTheme.textTheme.displayMedium,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Keep Password Safe Always',
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
                  PasswordInputField(
                    hintText: 'Password',
                    controller: pwdController,
                  ),
                  PasswordInputField(
                    hintText: 'Confirm Password',
                    controller: cnfrmPwdController,
                  ),
                ],
              ),
            ),
            // Gap(ScreenUtils.height10),
            PrimaryButton(
              label: 'Submit',
              onPressed: () {
                if (pwdController.text != cnfrmPwdController.text) return;
                GlobalService.closeKeyboard();
                Navigator.of(context).popAndPushNamed(AppRoute.imageAuth);
              },
            )
          ],
        ),
      ),
    );
  }
}
