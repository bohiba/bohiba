import '/pages/widget/required_label.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/controllers/update_contact_info_controller.dart';
import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateContactInfoPage extends GetView<UpdateContactInfoController> {
  const UpdateContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Update Contact'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
            top: ScreenUtils.height10,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RequiredLabel(label: 'Mobile Number', required: true),
                    TextInputField(
                      hintText: 'Mobile Number',
                      controller: controller.phoneController,
                    )
                  ],
                ),
              ),
              PrimaryButton(
                onPressed: () async {
                  Map<String, dynamic> bodyObj = {
                    'mobile_number': controller.phoneController.text.trim(),
                  };

                  await controller.updateContact(parameter: bodyObj);
                },
                label: 'Update Mobile Number',
              )
            ],
          ),
        ),
      ),
    );
  }
}
