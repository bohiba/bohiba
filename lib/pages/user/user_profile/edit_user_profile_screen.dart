import '/routes/app_route.dart';
import 'package:gap/gap.dart';

import '/component/bohiba_dropdown/app_dropdown_button.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

  final formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final navigatorState = Navigator.of(context);
    return Scaffold(
      appBar: const TitleAppbar(title: "Edit Profile"),
      body: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtils.width15,
          right: ScreenUtils.width15,
          bottom: ScreenUtils.height30,
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
              Gap(ScreenUtils.height10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: bohibaTheme.textTheme.labelLarge,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtils.height5),
                    child: TextInputField(
                      hintText: "Name",
                      controller: nameController,
                    ),
                  ),
                  Text(
                    "Phone Number",
                    style: bohibaTheme.textTheme.labelLarge,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtils.height5),
                    child: TextInputField(
                      hintText: "Mobile Number",
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Text(
                    "Email",
                    style: bohibaTheme.textTheme.labelLarge,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtils.height5),
                    child: TextInputField(
                      hintText: "example@mail.com",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Text(
                    "Update Role",
                    style: bohibaTheme.textTheme.labelLarge,
                  ),
                  AppDropdown(
                    items: <Map<String, dynamic>>[
                      {'role_id': 6, 'label': 'Truck Owner'},
                      {'role_id': 8, 'label': 'Driver'}
                    ],
                    labelBuilder: (p0) => p0['label'],
                    onChanged: (pv) {},
                  ),
                  /*Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtils.height5, bottom: ScreenUtils.height5),
                    child: TextFormField(
                      decoration: InputDecoration(
                          // hintText:
                          //     DateFormat("dd-MM-yyyy").format(DateTime.now()),
                          ),
                      style: bohibaTheme.textTheme.titleMedium,
                      controller: dobController,
                      readOnly: true,
                      onTap: () async {
                        dobController.text = await GlobalController.pickDate(
                            context: context,
                            dateFormatter: 'dd-MM-yyyy',
                            hintText: "Your DOB");
                      },
                    ),
                  ),*/
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigatorState.pushNamed(AppRoute.setting);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Agreed to ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            TextSpan(
                              text: 'Term & Conditions',
                              style: TextStyle(
                                color: bohibaTheme.primaryColor,
                                fontSize: 11,
                              ),
                            ),
                            const TextSpan(
                              text: ' & ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                  color: BohibaColors.primaryColor,
                                  // decoration: TextDecoration.underline,
                                  fontSize: 11),
                            )
                          ],
                        ),
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
    );
  }

  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }
}
