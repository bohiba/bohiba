import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/controllers/update_contact_info_controller.dart';
import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';
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
          child: Obx(() {
            return Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: ScreenUtils.height10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                RadioGroup(
                                  groupValue: controller.addAsset.value,
                                  onChanged: (AddAssetUsing? change) {
                                    controller.addAsset.value =
                                        change ?? AddAssetUsing.uuid;
                                  },
                                  child: Radio<AddAssetUsing>(
                                    value: AddAssetUsing.uuid,
                                  ),
                                ),
                                Text("Mobile Number",
                                    style: bohibaTheme.textTheme.titleLarge),
                              ],
                            ),
                            Row(
                              children: [
                                RadioGroup(
                                  groupValue: controller.addAsset.value,
                                  onChanged: (AddAssetUsing? change) {
                                    controller.addAsset.value =
                                        change ?? AddAssetUsing.doc;
                                  },
                                  child: Radio<AddAssetUsing>(
                                    value: AddAssetUsing.doc,
                                  ),
                                ),
                                Text("Email",
                                    style: bohibaTheme.textTheme.titleLarge),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (controller.addAsset.value == AddAssetUsing.uuid)
                        TextInputField(
                          hintText: 'Mobile Number',
                          controller: controller.phoneController,
                        )
                      else
                        TextInputField(
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          controller: controller.emailController,
                        ),
                    ],
                  ),
                ),
                PrimaryButton(
                  onPressed: () async {
                    Map bodyObj = {};
                    if (controller.addAsset.value == AddAssetUsing.uuid) {
                      bodyObj = {
                        'mobile_number': controller.phoneController.text.trim(),
                      };
                    } else {
                      if (controller.emailController.text.trim().isEmail) {
                        bodyObj = {
                          'email': controller.emailController.text
                              .trim()
                              .toLowerCase(),
                        };
                      } else {
                        GlobalService.showAppToast(message: 'Invalid Email');
                        return;
                      }
                    }
                    await controller.updateContact(parameter: bodyObj);
                  },
                  label: controller.addAsset.value == AddAssetUsing.uuid
                      ? 'Update Mobile Number'
                      : 'Update Email',
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
