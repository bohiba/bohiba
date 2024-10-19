import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../component/bohiba_buttons/primary_button.dart';
import '../../../component/bohiba_colors.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  const OtpScreen({this.email = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Verify PIN',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter 4 digit code you have received in $email.',
                style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.5,
                    color: bohibaColors.secoundaryColor),
              ),
            ),
            PinCodeTextField(
                appContext: context,
                length: 4,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                cursorColor: Theme.of(context).primaryColor,
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  fieldWidth: 50,
                  activeColor: Theme.of(context).primaryColor,
                  disabledColor: bohibaColors.secoundaryColor,
                  selectedFillColor: Theme.of(context).primaryColor,
                  inactiveColor: bohibaColors.secoundaryColor,
                  activeFillColor: Theme.of(context).primaryColor,
                )),
            PrimaryButton(
              label: 'VERIFY CODE',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
