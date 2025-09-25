import '/dist/component_exports.dart';
import '/pages/widget/required_label.dart';

import '/controllers/user_profile_config_controller.dart';
import '/dist/controller_exports.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';
import '/component/bohiba_buttons/primary_button.dart';
import 'package:flutter/material.dart';
import '/theme/bohiba_theme.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import 'all_location_modal.dart';

class AddressAuthPage extends GetView<UserProfileConfigController> {
  const AddressAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Add Address',
        actions: [
          AppBarIconBox(
            onTap: () {
              GlobalService.closeKeyboard();
              Get.bottomSheet(
                AllLocationModal(),
                shape: BottomModalShape(),
                ignoreSafeArea: false,
                isScrollControlled: true,
                backgroundColor: bohibaTheme.scaffoldBackgroundColor,
              ).then((address) {
                GlobalService.printHandler("Location  ${address.toString()}");
                if (address == null) {
                  return;
                }
                controller.aHouseCtrl.text = address['name'] ?? '';
                controller.aLocalityCtrl.text = address['locality'] ?? '';
                controller.aStreetCtrl.text = address['street'] ?? '';
                controller.aCityCtrl.text = address['city'] ?? '';
                controller.aDistrictCtrl.text = address['district'] ?? '';
                controller.aStateCtrl.text = address['state'] ?? '';
                controller.aPincodeCtrl.text = address['pincode'] ?? '';
                controller.aCountryCtrl.text = address['country'] ?? '';
              });
            },
            icon: Icon(EvaIcons.pinOutline),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtils.height15,
            horizontal: ScreenUtils.width20,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   "Verify Address",
                      //   style: bohibaTheme.textTheme.headlineLarge,
                      // ),
                      Text(
                        'Fill in your information to start getting matched with owners.',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleSmall!.color,
                        ),
                      ),
                      RequiredLabel(label: 'House No'),
                      TextInputField(
                        // hintText: "House No.",
                        controller: controller.aHouseCtrl,
                      ),

                      RequiredLabel(
                          label: 'Apartment/Colony/Locality', required: true),
                      TextInputField(
                        // hintText: "Apartment/Colony/Locality",
                        controller: controller.aLocalityCtrl,
                      ),

                      RequiredLabel(label: 'Street Address'),
                      TextInputField(
                        // hintText: "Street Address",
                        controller: controller.aStreetCtrl,
                      ),

                      RequiredLabel(label: 'City/Town/Village'),
                      TextInputField(
                        // hintText: "City/Town/Village",
                        controller: controller.aCityCtrl,
                      ),

                      RequiredLabel(label: 'Pin Code', required: true),
                      TextInputField(
                        hintText: "6-digit",
                        controller: controller.aPincodeCtrl,
                      ),

                      RequiredLabel(
                        label: 'District',
                        required: true,
                      ),
                      TextInputField(
                        // hintText: "District",
                        controller: controller.aDistrictCtrl,
                      ),

                      RequiredLabel(label: 'State', required: true),
                      TextInputField(
                        // hintText: "State",
                        controller: controller.aStateCtrl,
                      ),

                      RequiredLabel(label: 'Country', required: true),
                      TextInputField(
                        controller: controller.aCountryCtrl,
                        // hintText: "Country",
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                onPressed: () async => await controller.addAddress(),
                label: "Submit",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
