import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/dist/controller_exports.dart';
import 'package:bohiba/pages/vehicle/add_vehicle_widget/add_vehicle_input_field.dart';
import 'package:bohiba/pages/vehicle/vechile_dash_string/vehicle_dash_string.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class AddNewDriverModalSheet extends StatefulWidget {
  const AddNewDriverModalSheet({super.key});

  @override
  State<AddNewDriverModalSheet> createState() => _AddNewDriverModalSheetState();
}

class _AddNewDriverModalSheetState extends State<AddNewDriverModalSheet> {
  GlobalController globalController = Get.put(GlobalController());
  // Variable
  bool agree = false;
  TextInputType regdNoInputType = TextInputType.text;

  // Controller
  final regdNoController = TextEditingController();
  final driverNameController = TextEditingController();
  final driverLicenseController = TextEditingController();
  final dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: BohibaResponsiveScreen.width15,
        right: BohibaResponsiveScreen.width15,
      ),
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
          Padding(
            padding: EdgeInsets.only(
                left: BohibaResponsiveScreen.width15,
                right: BohibaResponsiveScreen.width15,
                top: BohibaResponsiveScreen.height15),
            child: Text(
              'Add New Driver',
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          Gap(BohibaResponsiveScreen.height10),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: BohibaResponsiveScreen.height10),
            child: Form(
                child: Column(
              children: [
                TextInputField(
                  prefixIcon: const Icon(EvaIcons.creditCardOutline),
                  hintText: VehicleDashString.driverLicense,
                  controller: driverLicenseController,
                  textCapitalization: TextCapitalization.characters,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DateInputField(
                      onTap: () async {
                        dateController.text = await globalController.pickDate(
                            dateFormatter: DateFormat('dd-MM-yyyy'),
                            hintText: 'Driver D.O.B');
                      },
                      hintText: 'D.O.B',
                      controller: dateController,
                    ),
                    const ChooseVehicleWheel(),
                  ],
                ),
                TextInputField(
                  prefixIcon: const Icon(EvaIcons.personOutline),
                  hintText: VehicleDashString.driverName,
                  controller: driverNameController,
                  textCapitalization: TextCapitalization.characters,
                ),
                TextInputField(
                  prefixIcon: const Icon(EvaIcons.hashOutline),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  hintText: VehicleDashString.driverMobileNumber,
                ),
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
                Gap(BohibaResponsiveScreen.height5),
                CheckboxListTile(
                  value: agree,
                  tileColor: bohibaColors.bgColor,
                  onChanged: (value) {
                    setState(() {
                      agree = !agree;
                    });
                  },
                  title: Text(
                    'I agree that above details are ture to my knowledge.',
                    style: bohibaTheme.textTheme.titleSmall,
                  ),
                ),
                PrimaryButton(
                  label: 'VERIFY',
                  onPressed: () {},
                ),
                Gap(BohibaResponsiveScreen.height15),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
