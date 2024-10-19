import 'package:bohiba/component/bohiba_buttons/primary_button.dart';
import 'package:bohiba/component/bohiba_inputfield/text_inputfield.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/vehicle/vechile_dash_string/vehicle_dash_string.dart';
import 'package:flutter/material.dart';

class EditModalSheet extends StatelessWidget {
  const EditModalSheet({super.key});

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
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10.0)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Text(
              'Edit Driver info',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: BohibaResponsiveScreen.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
                child: Column(
              children: [
                TextInputField(
                  hintText: VehicleDashString.driverName,
                  // controller: driverNameController,
                  textCapitalization: TextCapitalization.characters,
                ),
                TextInputField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  hintText: VehicleDashString.driverMobileNumber,
                ),
                const SizedBox(height: 5),
                PrimaryButton(
                  label: 'VERIFY',
                  onPressed: () {},
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}
