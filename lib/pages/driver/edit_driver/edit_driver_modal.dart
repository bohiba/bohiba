import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/screen_utils.dart';
import '/pages/vehicle/vechile_dash_string/vehicle_dash_string.dart';
import '/theme/light_theme.dart';

class EditDriverDetialsModalSheet extends StatelessWidget {
  const EditDriverDetialsModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.0,
            width: BohibaResponsiveScreen.width * 0.25,
            margin:
                EdgeInsets.symmetric(vertical: BohibaResponsiveScreen.height10),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: BohibaResponsiveScreen.width15,
              right: BohibaResponsiveScreen.width15,
              top: BohibaResponsiveScreen.height15,
            ),
            child: Text(
              'Edit Driver info',
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          Gap(BohibaResponsiveScreen.height10),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: BohibaResponsiveScreen.width15),
            child: Form(
                child: Column(
              children: [
                TextInputField(
                  hintText: VehicleDashString.driverName,
                  textCapitalization: TextCapitalization.characters,
                ),
                TextInputField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  hintText: VehicleDashString.driverMobileNumber,
                ),
                Gap(BohibaResponsiveScreen.height10),
                PrimaryButton(
                  label: 'ADD DRIVER',
                  onPressed: () {},
                ),
                Gap(BohibaResponsiveScreen.height50),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
