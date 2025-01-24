import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/dist/controller_exports.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bohiba/component/bohiba_inputfield/text_inputfield.dart';

import '../../../component/bohiba_buttons/bottom_button.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final GlobalController _globalController = Get.put(GlobalController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

  final formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const TitleAppbar(
        title: "Edit Profile",
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.only(
          // top: BohibaResponsiveScreen.height20,
          left: BohibaResponsiveScreen.width15,
          right: BohibaResponsiveScreen.width15,
          bottom: BohibaResponsiveScreen.height30,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Setup Profile',
                style: bohibaTheme.textTheme.displayMedium,
              ),
              Text(
                'Please set your profile to get started',
                style: bohibaTheme.textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: bohibaTheme.textTheme.labelLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: BohibaResponsiveScreen.height5),
                      child: TextInputField(
                        hintText: "Mangal Kishore Mahanta",
                        controller: nameController,
                      ),
                    ),
                    Text(
                      "Phone Number",
                      style: bohibaTheme.textTheme.labelLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: BohibaResponsiveScreen.height5),
                      child: TextInputField(
                        hintText: "000 000 0000",
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    Text(
                      "Email",
                      style: bohibaTheme.textTheme.labelLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: BohibaResponsiveScreen.height5),
                      child: TextInputField(
                        hintText: "example@mail.com",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Text(
                      "DOB",
                      style: bohibaTheme.textTheme.labelLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: BohibaResponsiveScreen.height5,
                          bottom: BohibaResponsiveScreen.height5),
                      child: TextFormField(
                        decoration: InputDecoration(
                            // hintText:
                            //     DateFormat("dd-MM-yyyy").format(DateTime.now()),
                            ),
                        style: bohibaTheme.textTheme.titleMedium,
                        controller: dobController,
                        readOnly: true,
                        onTap: () async {
                          dobController.text = await _globalController.pickDate(
                              dateFormatter: DateFormat('dd-MM-yyyy'),
                              hintText: "Your DOB");
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: BohibaResponsiveScreen.width15),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Agreed to ',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          TextSpan(
                            text: 'Term & Conditions',
                            style: TextStyle(
                              color: bohibaColors.primaryColor,
                              // decoration: TextDecoration.underline,
                              fontSize: 11,
                            ),
                          ),
                          const TextSpan(
                            text: ' & ',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                                color: bohibaColors.primaryColor,
                                // decoration: TextDecoration.underline,
                                fontSize: 11),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButton(
        width: width,
        onTap: () {
          debugPrint(
              "\n-------------\n| is_checked: $isChecked |\n-------------\n");
        },
        labelPrice: "SUBMIT",
      ),
    );
  }

  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }
}
