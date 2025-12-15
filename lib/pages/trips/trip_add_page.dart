import 'package:gap/gap.dart';

import '/model/truck_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/pages/widget/required_label.dart';
import '/extensions/bohiba_extension.dart';
import '/dist/component_exports.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_dropdown/app_dropdown_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/controllers/trip_add_controller.dart';
import '/services/global_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTripPage extends GetView<TripAddController> {
  const AddTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: controller.tripModel.value == null ? 'Add Trip' : 'Edit Trip',
          popResult: controller.countUpdate > 0 ? true : false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: ScreenUtils.height15,
                right: ScreenUtils.height15,
                top: ScreenUtils.height10,
              ),
              child: Form(
                key: controller.globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateInputField(
                          width: ScreenUtils.width * 0.45,
                          hintText: 'Start Date',
                          controller: controller.startAtController,
                          validateField: (inputValue) {
                            if (inputValue == null || inputValue.isEmpty) {
                              return 'Date is required';
                            } else {
                              return null;
                            }
                          },
                          onTap: () async {
                            DateTime? pickedDate = await GlobalService.datePickerModal(context: context);
                            if (pickedDate != null) {
                              controller.startAtController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                            }
                          },
                        ),
                        DateInputField(
                          width: ScreenUtils.width * 0.45,
                          hintText: 'End Date',
                          controller: controller.endedAtController,
                          validateField: (inputValue) {
                            if (inputValue == null || inputValue.isEmpty) {
                              return 'Date is required';
                            } else {
                              return null;
                            }
                          },
                          onTap: () async {
                            if (controller.startAtController.text.isEmpty) {
                              GlobalService.showAppToast(message: 'Please select start date');
                            } else {
                              DateTime? pickedDate = await GlobalService.datePickerModal(
                                context: context,
                                startTime: DateFormat('dd-MM-yyyy').parse(controller.startAtController.text),
                              );
                              if (pickedDate != null) {
                                controller.endedAtController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    RequiredLabel(
                      label: 'Truck Number',
                      required: true,
                    ),
                    AppDropdown<TruckModel>(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      menuHeight: ScreenUtils.height * 0.45,
                      hint: 'Select Truck',
                      items: controller.arrTruck.value,
                      initialValue: controller.truckModel.value,
                      labelBuilder: (truck) {
                        return truck.regdNumber!;
                      },
                      menuController: controller.truckController,
                      onChanged: (t1) {
                        if (t1?.driverUuid == null) return;

                        controller.truckModel.value.driverUuid = t1?.driverUuid;
                      },
                      validator: (value) {
                        if (value == null || value.regdNumber == null) {
                          return 'Please select your truck.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    RequiredLabel(label: 'Origin', required: true),
                    TextInputField(
                      hintText: 'Company Name',
                      controller: controller.originController,
                      textCapitalization: TextCapitalization.characters,
                      nextActionType: TextInputAction.next,
                      validateField: (inputValue) {
                        if (inputValue == null || inputValue.isEmpty) {
                          return 'Please enter origin';
                        } else {
                          return null;
                        }
                      },
                    ),
                    RequiredLabel(label: 'Destination', required: true),
                    TextInputField(
                      hintText: 'Company Name',
                      controller: controller.destinationController,
                      textCapitalization: TextCapitalization.characters,
                      nextActionType: TextInputAction.next,
                      validateField: (inputValue) {
                        if (inputValue == null || inputValue.isEmpty) {
                          return 'Please enter destination';
                        } else {
                          return null;
                        }
                      },
                    ),
                    RequiredLabel(label: 'Transporter', required: true),
                    TextInputField(
                      controller: controller.transporterController,
                      textCapitalization: TextCapitalization.characters,
                      nextActionType: TextInputAction.next,
                      validateField: (inputValue) {
                        if (inputValue == null || inputValue.isEmpty) {
                          return 'Please enter Transporter Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    AppDropdown(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      hint: 'Material Type*',
                      initialValue: controller.strOre.value,
                      items: controller.ironOreTypes,
                      menuController: controller.materialController,
                      labelBuilder: (String p1) {
                        return p1.toCapitalizedLabel();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select material';
                        } else {
                          return null;
                        }
                      },
                    ),
                    AppDropdown(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      hint: 'Trip Status',
                      initialValue: controller.strStatus.value,
                      items: controller.tripStatus,
                      enableSearch: false,
                      labelBuilder: (String p1) {
                        return p1.toCapitalizedLabel();
                      },
                      menuController: controller.statusController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select trip status';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredLabel(label: 'Total Weight', required: true),
                            TextInputField(
                              width: ScreenUtils.width * 0.44,
                              hintText: '00.00 in Tonne',
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              nextActionType: TextInputAction.next,
                              controller: controller.totalWeightController,
                              validateField: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select weight';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredLabel(label: 'Short Weight'),
                            TextInputField(
                              width: ScreenUtils.width * 0.44,
                              hintText: '00.00 in Tonne',
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              nextActionType: TextInputAction.next,
                              controller: controller.shortWeightController,
                            ),
                          ],
                        )
                      ],
                    ),
                    RequiredLabel(label: 'Trip Price /Tonne', required: true),
                    TextInputField(
                      hintText: 'Rate/Tonne',
                      keyboardType: TextInputType.number,
                      nextActionType: TextInputAction.next,
                      controller: controller.rateController,
                    ),
                    Gap(50.h),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: ScreenUtils.height15,
              right: ScreenUtils.height15,
            ),
            child: PrimaryButton(
              onPressed: () => controller.addUpdateTrip(),
              label: 'Save',
            ),
          ),
        ),
      );
    });
  }
}
