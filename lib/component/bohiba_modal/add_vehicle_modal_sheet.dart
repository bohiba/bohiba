import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';
import '/pages/vehicle/vechile_dash_string/vehicle_dash_string.dart';
import '/pages/vehicle/add_vehicle_widget/add_vehicle_input_field.dart';
import '../bohiba_buttons/primary_button.dart';
import '../bohiba_inputfield/text_inputfield.dart';
import '../screen_utils.dart';

class AddVehicleModalSheet extends StatefulWidget {
  const AddVehicleModalSheet({super.key});

  @override
  State<AddVehicleModalSheet> createState() => _AddVehicleModalSheetState();
}

class _AddVehicleModalSheetState extends State<AddVehicleModalSheet> {
  // Variable
  bool agree = false;
  TextInputType regdNoInputType = TextInputType.text;

  // Controller
  final TextEditingController regdNoController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController driverLicenseController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final GlobalKey formKey = GlobalKey<FormState>();

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
                  // BohibaDropDown(
                  //   items: ["Ram", "Shyam", "Filmon"],
                  //   hint: "Select your Driver",
                  // ),

                  TextInputField(
                    prefixIcon: const Icon(EvaIcons.creditCardOutline),
                    hintText: VehicleDashString.driverLicense,
                    controller: driverLicenseController,
                    textCapitalization: TextCapitalization.characters,
                  ),

                  Row(
                    children: [
                      const ChooseVehicleWheel(),
                      TextInputField(
                        prefixIcon: const Icon(EvaIcons.hashOutline),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        hintText: VehicleDashString.driverMobileNumber,
                      ),
                    ],
                  ),
                  // TextInputField(
                  //   prefixIcon: const Icon(EvaIcons.personOutline),
                  //   hintText: VehicleDashString.driverName,
                  //   controller: driverNameController,
                  //   textCapitalization: TextCapitalization.characters,
                  // ),
                  // Row(
                  //   children: [
                  //     const Spacer(),
                  //     DateInputField(
                  //       // restorationId: 'main',
                  //       hintText: 'D.O.B',
                  //       controller: dateController,
                  //     ),
                  //   ],
                  // ),
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
                  ),
                  Gap(BohibaResponsiveScreen.height50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
