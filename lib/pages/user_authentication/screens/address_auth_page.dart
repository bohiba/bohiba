import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/controllers/user_profile_config_controller.dart';
import '/dist/controller_exports.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:gap/gap.dart';
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtils.height15,
              horizontal: ScreenUtils.width20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Verify Address",
                  style: bohibaTheme.textTheme.headlineLarge,
                ),
                Text(
                  'Fill in your information to start getting matched with owners.',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleSmall!.color,
                  ),
                ),
                TextInputField(
                  hintText: "House No.",
                  controller: controller.aHouseCtrl,
                ),
                TextInputField(
                  hintText: "Apartment/Colony/Locality",
                  controller: controller.aLocalityCtrl,
                ),
                TextInputField(
                  hintText: "Street Address",
                  controller: controller.aStreetCtrl,
                ),
                TextInputField(
                  hintText: "City/Town/Village",
                  controller: controller.aCityCtrl,
                ),
                TextInputField(
                  hintText: "Pin Code",
                  controller: controller.aPincodeCtrl,
                ),
                TextInputField(
                    hintText: "District", controller: controller.aDistrictCtrl),
                TextInputField(
                  hintText: "State",
                  controller: controller.aStateCtrl,
                ),
                TextInputField(
                  controller: controller.aCountryCtrl,
                  hintText: "Country",
                ),
                // Spacer(),
                Gap(ScreenUtils.height10),
                PrimaryButton(
                  onPressed: () async {
                    // Get.offAndToNamed(AppRoute.imageAuth);
                    await controller.addAddress(
                      txtHouse: controller.aHouseCtrl.text.trim(),
                      txtLocality: controller.aLocalityCtrl.text.trim(),
                      txtStreet: controller.aStreetCtrl.text.trim(),
                      txtCity: controller.aCityCtrl.text.trim(),
                      txtPincode: controller.aPincodeCtrl.text.trim(),
                      txtDist: controller.aDistrictCtrl.text.trim(),
                      txtState: controller.aStateCtrl.text.trim(),
                      txtCountry: controller.aCountryCtrl.text.trim(),
                    );
                  },
                  label: "Submit",
                ),

                Gap(ScreenUtils.height25),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      GlobalService.closeKeyboard();
                      Get.bottomSheet(
                        AllLocationModal(),
                        shape: BottomModalShape(),
                        ignoreSafeArea: false,
                        isScrollControlled: true,
                        backgroundColor: BohibaColors.transparent,
                      ).then((address) {
                        GlobalService.printHandler(
                            "Location  ${address.toString()}");
                        if (address == null) {
                          return;
                        }
                        controller.aHouseCtrl.text = address['name'] ?? '';
                        controller.aLocalityCtrl.text =
                            address['locality'] ?? '';
                        controller.aStreetCtrl.text = address['street'] ?? '';
                        controller.aCityCtrl.text = address['city'] ?? '';
                        controller.aDistrictCtrl.text =
                            address['district'] ?? '';
                        controller.aStateCtrl.text = address['state'] ?? '';
                        controller.aPincodeCtrl.text = address['pincode'] ?? '';
                        controller.aCountryCtrl.text = address['country'] ?? '';
                      });
                    },
                    icon: Icon(EvaIcons.pinOutline),
                    label: Text('Fetch location automatically'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
