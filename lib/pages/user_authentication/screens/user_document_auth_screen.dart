import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_inputfield/input_formatters/aadhar_number_formatter.dart';
import '/component/bohiba_inputfield/user_auth_image_upload.dart';

class UserDocAuthScreen extends StatefulWidget {
  const UserDocAuthScreen({super.key});

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
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
            UserAuthContainerImageUpload(
              label: 'Upload your Aadhar-image',
              onTap: () {},
            ),
            SizedBox(height: height * 0.02),
            TextInputField(
              maxLength: 10,
              hintText: "Pan Number",
              keyboardType: keyboardType,
              textCapitalization: TextCapitalization.characters,
              onChanged: (value) {},
            ),
            UserAuthContainerImageUpload(
              label: 'Upload your PAN-image',
              onTap: () {},
            ),
            UserAuthContainerImageUpload(
              label: "Upload your Signature",
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
