import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bohiba/utils/bohiba_appbar/title_appbar.dart';
import 'package:bohiba/utils/bohiba_inputfield/text_inputfield.dart';

import '../../../utils/bohiba_buttons/bottom_button.dart';
import '../../../utils/bohiba_colors.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isChecked = true;

  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Setup Profile',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                'Please set your profile to get started',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextInputField(
                        hintText: "Mangal Kishore Mahanta",
                        controller: nameController,
                      ),
                    ),
                    Text(
                      "Phone Number",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextInputField(
                        hintText: "000 000 0000",
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    Text(
                      "Email",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextInputField(
                        hintText: "example@mail.com",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Text(
                      "DOB",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: DateFormat("dd-MM-yyyy")
                                .format(DateTime.now())),
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: dobController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  1900), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);

                            setState(() {
                              dobController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            dobController.text = "Date not selected";
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  trailing: Radio(
                      toggleable: true,
                      value: 'agree',
                      groupValue: 'agree',
                      activeColor: bohibaColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          isChecked = false;
                        });
                      }),
                  title: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                      text: 'Agreed to ',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    TextSpan(
                      text: 'Term & Conditions',
                      style: TextStyle(
                          color: bohibaColors.primaryColor,
                          decoration: TextDecoration.underline,
                          fontSize: 11),
                    ),
                    const TextSpan(
                      text: ' & ',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                          color: bohibaColors.primaryColor,
                          decoration: TextDecoration.underline,
                          fontSize: 11),
                    )
                  ])),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButton(
        width: width,
        onTap: () {
          debugPrint("Value");
        },
        labelPrice: "SUBMIT",
      ),
    );
  }
}
