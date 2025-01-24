// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bohiba/component/bohiba_dropdown/bohiba_dropdown.dart';

import '/component/bohiba_buttons/document_image_picker_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '../user_auth_string.dart';

class UserAddressAuthPage extends StatefulWidget {
  const UserAddressAuthPage({super.key});

  @override
  State<UserAddressAuthPage> createState() => _UserAddressAuthPageState();
}

class _UserAddressAuthPageState extends State<UserAddressAuthPage> {
  String? dropdownValue;
  List<String> items = [
    'Aadhaar Card',
    'Ration Card',
    'Electric Bill',
    'Income Tax Assessment Order',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  UserAddressAuthString.addAuth,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              )),
          Container(
            height: 47,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1.0, color: Colors.grey.shade300)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: const Text('Choose your address'),
                value: dropdownValue,
                style: Theme.of(context).textTheme.bodyMedium,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                  debugPrint(value);
                },
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Visibility(
              maintainState: true,
              maintainAnimation: true,
              visible: dropdownValue == null || dropdownValue == "Aadhaar Card"
                  ? false
                  : true,
              child: DocumentImagePicker(
                label: "Upload your $dropdownValue",
              )),
          TextInputField(
            hintText: UserAddressAuthString.houseNo,
          ),
          TextInputField(
            hintText: UserAddressAuthString.colonyLocality,
          ),
          TextInputField(
            hintText: UserAddressAuthString.streetAddress,
          ),
          TextInputField(
            hintText: UserAddressAuthString.city,
          ),
          TextInputField(
            hintText: UserAddressAuthString.pin,
          ),
          TextInputField(
            hintText: UserAddressAuthString.district,
          ),
          TextInputField(
            hintText: UserAddressAuthString.state,
          ),
          TextInputField(
            controller: TextEditingController(text: 'India'),
            hintText: UserAddressAuthString.country,
          )
        ],
      ),
    );
  }
}
