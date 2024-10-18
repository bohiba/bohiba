import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bohiba/utils/bohiba_inputfield/text_inputfield.dart';

import '../../../../utils/bohiba_inputfield/input_formatters/aadhar_number_formatter.dart';
import '../../user_auth_widget/user_auth_image_upload/user_auth_image_upload.dart';

class UserDocAuthScreen extends StatefulWidget {
  const UserDocAuthScreen({Key? key}) : super(key: key);

  @override
  State<UserDocAuthScreen> createState() => _UserDocAuthScreenState();
}

class _UserDocAuthScreenState extends State<UserDocAuthScreen> {
  TextInputType keyboardType = TextInputType.text;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Document Authentication",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                )),
            TextInputField(
              maxLength: 19,
              hintText: "Aadhaar Number",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                AadhaarNumberFormatter()
              ],
              onChanged: (v) {
                debugPrint(v.length.toString());
              },
            ),
            const UserAuthContainerImageUpload(
              label: 'Upload your Aadhar-image',
            ),
            SizedBox(height: height * 0.02),
            TextInputField(
              maxLength: 10,
              hintText: "Pan Number",
              keyboardType: keyboardType,
              textCapitalization: TextCapitalization.characters,
              onChanged: (value) {},
            ),
            // Discard the class
            // const DocumentImagePicker(
            //   label: 'Upload your PAN image',
            // ),
            const UserAuthContainerImageUpload(
              label: 'Upload your PAN-image',
            ),
            const UserAuthContainerImageUpload(label: "Upload your Signature")
          ],
        ),
      ),
    );
  }
}
