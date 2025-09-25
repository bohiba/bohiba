import '/services/global_service.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/dist/component_exports.dart';
import '/pages/truck/add_truck_widget/add_vehicle_input_field.dart';
import '/pages/truck/vechile_dash_string/vehicle_dash_string.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class AddNewDriverModalSheet extends StatefulWidget {
  const AddNewDriverModalSheet({super.key});

  @override
  State<AddNewDriverModalSheet> createState() => _AddNewDriverModalSheetState();
}

class _AddNewDriverModalSheetState extends State<AddNewDriverModalSheet> {
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
        left: ScreenUtils.width15,
        right: ScreenUtils.width15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.0,
            width: ScreenUtils.width * 0.25,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10.0)),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtils.width15,
                right: ScreenUtils.width15,
                top: ScreenUtils.height15),
            child: Text(
              'Add New Driver',
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          Gap(ScreenUtils.height10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtils.height10),
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
                        dateController.text = await GlobalService.pickDate(
                            context: context,
                            dateFormatter: 'dd-MM-yyyy',
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
                Gap(ScreenUtils.height5),
                CheckboxListTile(
                  value: agree,
                  tileColor: BohibaColors.bgColor,
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
                Gap(ScreenUtils.height15),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
