import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class ForgotUuidPage extends StatelessWidget {
  const ForgotUuidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width20,
        ),
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
            TextInputField(
              hintText: 'PAN Number',
            ),
            TextInputField(
              hintText: 'Aadhar Number',
            ),
            PrimaryButton(
              onPressed: () {},
              label: 'Verify',
            )
          ],
        ),
      ),
    );
  }
}
