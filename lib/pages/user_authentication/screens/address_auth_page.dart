import '/dist/enums/app_enums.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';
import '/pages/widget/required_label.dart';
import '/component/bohiba_appbar/appbar_icon.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';

import '/controllers/address_auth_controller.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'all_location_modal.dart';

class AddressAuthPage extends GetView<AddressAuthController> {
  const AddressAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigateState = Navigator.of(context);
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: 'Add Address',
          showLeading: controller.enableLeading.value,
          actions: [
            AppBarIconBox(
              onTap: () {
                GlobalService.closeKeyboard();
                showModalBottomSheet(
                    context: context,
                    shape: BottomModalShape(),
                    useSafeArea: true,
                    isScrollControlled: true,
                    enableDrag: true,
                    builder: (context) {
                      return AllLocationModal();
                    }).then((address) {
                  if (address == null) {
                    return;
                  }
                  controller.aHouseCtrl.text = address['name'] ?? '';
                  controller.aLocalityCtrl.text = address['locality'] ?? '';
                  controller.aStreetCtrl.text =
                      '${address['street']}, ${address['locality']}';
                  controller.aCityCtrl.text = address['city'] ?? '';
                  controller.aDistrictCtrl.text = address['district'] ?? '';
                  controller.aStateCtrl.text = address['state'] ?? '';
                  controller.aPincodeCtrl.text = address['pincode'] ?? '';
                  controller.aCountryCtrl.text = address['country'] ?? '';
                });
                /*Get.bottomSheet(
                  AllLocationModal(),
                  shape: BottomModalShape(),
                  ignoreSafeArea: false,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                ).then((address) {
                  if (address == null) {
                    return;
                  }
                  controller.aHouseCtrl.text = address['name'] ?? '';
                  controller.aLocalityCtrl.text = address['locality'] ?? '';
                  controller.aStreetCtrl.text =
                      '${address['street']}, ${address['locality']}';
                  controller.aCityCtrl.text = address['city'] ?? '';
                  controller.aDistrictCtrl.text = address['district'] ?? '';
                  controller.aStateCtrl.text = address['state'] ?? '';
                  controller.aPincodeCtrl.text = address['pincode'] ?? '';
                  controller.aCountryCtrl.text = address['country'] ?? '';
                });*/
              },
              icon: Icon(RemixIcons.map_pin_fill),
            )
          ],
        ),
        body: PopScope(
          canPop: controller.enableLeading.value,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop == true) {
              return;
            } else {
              GlobalService.showAlertDialog(
                status: AlertStatus.failure,
                title: 'Verification',
                description:
                    'Are your sure? You want to discontinue you verification process',
                discardBtnTxt: 'No',
                saveBtnTxt: 'Yes',
                onSave: () {
                  navigateState.pop();
                  navigateState.pop(true);
                },
              );
            }
          },
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                top: ScreenUtils.height15,
                left: ScreenUtils.width20,
                right: ScreenUtils.width20,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: controller.addressAuthKey,
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
                                fontSize:
                                    bohibaTheme.textTheme.bodySmall!.fontSize,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.titleSmall!.color,
                              ),
                            ),
                            RequiredLabel(label: 'House No'),
                            TextInputField(
                              controller: controller.aHouseCtrl,
                              nextActionType: TextInputAction.next,
                            ),
                            RequiredLabel(
                                label: 'Colony/Locality', required: true),
                            TextInputField(
                              controller: controller.aLocalityCtrl,
                              nextActionType: TextInputAction.next,
                              validateField: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
                                  return 'Locality cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            RequiredLabel(label: 'Street Address'),
                            TextInputField(
                              controller: controller.aStreetCtrl,
                              nextActionType: TextInputAction.next,
                            ),
                            RequiredLabel(label: 'City/Village'),
                            TextInputField(
                              controller: controller.aCityCtrl,
                              nextActionType: TextInputAction.next,
                              validateField: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
                                  return 'City/Village cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            RequiredLabel(label: 'Pin Code', required: true),
                            TextInputField(
                              hintText: "6-digit",
                              controller: controller.aPincodeCtrl,
                              keyboardType: TextInputType.number,
                              nextActionType: TextInputAction.next,
                              validateField: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
                                  return 'Pin Code cannot be empty';
                                } else if (inputValue.length != 6) {
                                  return 'Please enter valid PIN code';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            RequiredLabel(label: 'District', required: true),
                            TextInputField(
                              controller: controller.aDistrictCtrl,
                              nextActionType: TextInputAction.next,
                              validateField: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
                                  return 'District cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            RequiredLabel(label: 'State', required: true),
                            TextInputField(
                              controller: controller.aStateCtrl,
                              nextActionType: TextInputAction.next,
                              validateField: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
                                  return 'State cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            RequiredLabel(label: 'Country', required: true),
                            TextInputField(
                              controller: controller.aCountryCtrl,
                              // hintText: "Country",
                              validateField: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
                                  return 'Country cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  PrimaryButton(
                    onPressed: () async {
                      int success = await controller.addAddress();
                      if (success > 0) {
                        navigateState.popAndPushNamed(
                          AppRoute.imageAuth,
                          arguments: {
                            'canPop': false,
                            'route': AppRoute.roleType,
                            'canSkip': true,
                          },
                        );
                      }
                    },
                    label: "Submit",
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
