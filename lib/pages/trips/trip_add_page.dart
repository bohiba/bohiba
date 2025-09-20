import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '/dist/component_exports.dart';
import '/component/bohiba_dropdown/primary_dropdown_menu.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_dropdown/app_dropdown_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/controllers/trip_add_controller.dart';
import 'package:flutter/material.dart';
import '/services/global_service.dart';

class AddTripPage extends GetView<TripAddController> {
  const AddTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: TitleAppbar(
          title: controller.tripModel == null ? 'Add Trip' : 'Edit Trip',
        ),
        body: Obx(() {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: ScreenUtils.height20,
                left: ScreenUtils.height15,
                right: ScreenUtils.height15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DateInputField(
                        width: ScreenUtils.width * 0.45,
                        hintText: 'Start Date',
                        controller: controller.startAtController,
                        onTap: () async {
                          DateTime pickedDate =
                              await GlobalService.datePickerModal(
                                  context: context);
                          controller.startAtController.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                        },
                      ),
                      DateInputField(
                        width: ScreenUtils.width * 0.45,
                        hintText: 'Ended Date',
                        controller: controller.endedAtController,
                        onTap: () async {
                          DateTime pickedDate =
                              await GlobalService.datePickerModal(
                                  context: context);
                          controller.endedAtController.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                        },
                      ),
                    ],
                  ),
                  AppDropdown(
                    hint: 'Select Truck',
                    items: controller.arrTruck.value,
                    labelBuilder: (truck) => truck.regdNumber!,
                    menuController: controller.truckController,
                    onChanged: (t1) {
                      controller.truckModel.value = t1!;
                    },
                  ),
                  Text('Origin'),
                  TextInputField(
                    hintText: 'Company Name',
                    controller: controller.originController,
                    textCapitalization: TextCapitalization.characters,
                    nextActionType: TextInputAction.next,
                  ),
                  Text('Destination'),
                  TextInputField(
                    hintText: 'Company Name',
                    controller: controller.destinationController,
                    textCapitalization: TextCapitalization.characters,
                    nextActionType: TextInputAction.next,
                  ),
                  PrimaryDropDownMenu(
                    width: ScreenUtils.width,
                    hint: 'Material Type',
                    items: controller.ironOreTypes,
                    menuController: controller.materialController,
                  ),
                  PrimaryDropDownMenu(
                    width: ScreenUtils.width,
                    hint: 'Trip Status',
                    items: controller.tripStatus,
                    enableSearch: false,
                    menuController: controller.statusController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Weight'),
                          TextInputField(
                            width: ScreenUtils.width * 0.44,
                            hintText: 'in Tonne',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            nextActionType: TextInputAction.next,
                            controller: controller.totalWeightController,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Short Weight'),
                          TextInputField(
                            width: ScreenUtils.width * 0.44,
                            hintText: 'in Tonne',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            nextActionType: TextInputAction.next,
                            controller: controller.shortWeightController,
                          ),
                        ],
                      )
                    ],
                  ),
                  Text('Trip Price'),
                  TextInputField(
                    hintText: 'Rate/Tonne',
                    keyboardType: TextInputType.number,
                    nextActionType: TextInputAction.next,
                    controller: controller.rateController,
                  ),
                ],
              ),
            ),
          );
        }),
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
      ),
    );
  }
}
