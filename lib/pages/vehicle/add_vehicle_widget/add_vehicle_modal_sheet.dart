import 'package:bohiba/component/bohiba_inputfield/date_inputfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../component/bohiba_buttons/primary_button.dart';
import '../../../component/bohiba_inputfield/text_inputfield.dart';
import '../vechile_dash_string/vehicle_dash_string.dart';
import 'add_vehicle_input_field.dart';

class AddVehicleModalSheet extends StatefulWidget {
  const AddVehicleModalSheet({Key? key}) : super(key: key);

  @override
  State<AddVehicleModalSheet> createState() => _AddVehicleModalSheetState();
}

class _AddVehicleModalSheetState extends State<AddVehicleModalSheet> {
  // Variable
  bool agree = false;
  TextInputType regdNoInputType = TextInputType.text;

  // Controller
  final regdNoController = TextEditingController();
  final driverNameController = TextEditingController();
  final driverLicenseController = TextEditingController();
  final dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.0,
            width: width * 0.25,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10.0)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Text(
              'Vehicle Registration',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextInputField(
                      prefixIcon: const Icon(Remix.truck_line),
                      maxLength: 10,
                      readOnly: false,
                      hintText: VehicleDashString.vehicleNo,
                      keyboardType: regdNoInputType,
                      textCapitalization: TextCapitalization.characters,
                      controller: regdNoController,
                      onChanged: (v) {},
                    ),
                    TextInputField(
                      prefixIcon: const Icon(EvaIcons.personOutline),
                      hintText: VehicleDashString.driverName,
                      controller: driverNameController,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    TextInputField(
                      prefixIcon: const Icon(EvaIcons.creditCardOutline),
                      hintText: VehicleDashString.driverLicense,
                      controller: driverLicenseController,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    TextInputField(
                      prefixIcon: const Icon(EvaIcons.hashOutline),
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      hintText: VehicleDashString.driverMobileNumber,
                    ),
                    Row(
                      children: [
                        const ChooseVehicleWheel(),
                        const Spacer(),
                        DateInputField(
                          restorationId: 'main',
                          hintText: 'D.O.B',
                          controller: dateController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CheckboxListTile(
                      value: agree,
                      onChanged: (value) {
                        setState(() {
                          agree = !agree;
                        });
                      },
                      title: const Text(
                        'I agree that above details are ture to my knowledge.',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
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
