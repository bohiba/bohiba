import '/dist/component_exports.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';
import '../../pages/truck/vechile_dash_string/vehicle_dash_string.dart';
import '../../pages/truck/add_truck_widget/add_vehicle_input_field.dart';
import '../bohiba_buttons/primary_button.dart';
import '../bohiba_inputfield/text_inputfield.dart';

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
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.0,
            width: ScreenUtils.width * 0.25,
            margin: EdgeInsets.symmetric(vertical: ScreenUtils.height10),
            decoration: BoxDecoration(
                color: BohibaColors.lightGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: ScreenUtils.width15,
              right: ScreenUtils.width15,
              top: ScreenUtils.height15,
            ),
            child: Text(
              'Vehicle Registration',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Gap(ScreenUtils.height10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextInputField(
                    prefixIcon: const Icon(
                      Remix.user_3_fill,
                      size: 20,
                    ),
                    hintText: VehicleDashString.driverLicense,
                    controller: driverLicenseController,
                    textCapitalization: TextCapitalization.characters,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ChooseVehicleWheel(),
                      TextInputField(
                        width: ScreenUtils.width * 0.60,
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
                  Gap(ScreenUtils.height50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
