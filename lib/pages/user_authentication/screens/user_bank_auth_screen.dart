import 'package:flutter/material.dart';
import 'package:bohiba/pages/user_authentication/user_auth_string.dart';

import '/component/bohiba_dropdown/bohiba_dropdown.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_inputfield/user_auth_image_upload.dart';

class UserBankAuthScreen extends StatefulWidget {
  const UserBankAuthScreen({super.key});

  @override
  State<UserBankAuthScreen> createState() => _UserBankAuthpagestate();
}

class _UserBankAuthpagestate extends State<UserBankAuthScreen> {
  List<String> items = [
    "SBI",
    "PNB",
    "HDFC",
    "ICICI",
    "Axis Bank of India",
    "Kotak Mahindra",
  ];

  TextInputType keyboardType = TextInputType.text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                UserBankAuthString.bankAuth,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          BohibaDropDown(
            hint: "Choose your bank",
            items: items,
          ),
          TextInputField(
            hintText: UserBankAuthString.acNo,
            keyboardType: TextInputType.number,
          ),
          TextInputField(
            maxLength: 11,
            keyboardType: keyboardType,
            textCapitalization: TextCapitalization.characters,
            hintText: UserBankAuthString.ifsc,
            onChanged: (value) {
              if (value.length == 4 && keyboardType == TextInputType.text) {
                FocusScope.of(context).unfocus();
                setState(() {
                  keyboardType = TextInputType.number;
                });
                Future.delayed(const Duration(milliseconds: 150)).then((value) {
                  FocusScope.of(context).requestFocus();
                });
              } else if (value.isEmpty) {
                FocusScope.of(context).unfocus();
                setState(() {
                  keyboardType = TextInputType.text;
                });
                Future.delayed(const Duration(milliseconds: 150)).then((value) {
                  FocusScope.of(context).requestFocus();
                });
              } else {}
            },
          ),
          const UserAuthContainerImageUpload(
            label: "Upload your Passbook Front Page",
          ),
        ],
      ),
    );
  }
}
