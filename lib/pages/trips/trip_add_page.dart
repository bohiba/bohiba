import '/dist/enums/enum_trip_status.dart';
import '/model/truck_model.dart';
import '/model/company_model.dart';
import '/dist/component_exports.dart';
import '/services/global_service.dart';
import '/extensions/bohiba_extension.dart';
import '/pages/widget/required_label.dart';
import '/controllers/trip_add_controller.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_dropdown/app_search_dropdown_button.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                top: ScreenUtils.height15,
              ),
              child: Form(
                key: controller.globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Start / End dates ──────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateInputField(
                          width: ScreenUtils.width * 0.45,
                          hintText: 'Start Date',
                          controller: controller.startAtController,
                          validateField: (v) => (v == null || v.isEmpty)
                              ? 'Date is required'
                              : null,
                          onTap: () async {
                            final picked = await GlobalService.datePickerModal(
                                title: 'Trip Start Date', context: context);
                            if (picked != null) {
                              controller.startAtController.text =
                                  DateFormat('dd-MM-yyyy').format(picked);
                            }
                          },
                        ),
                        DateInputField(
                          width: ScreenUtils.width * 0.45,
                          hintText: 'End Date',
                          controller: controller.endedAtController,
                          validateField: (v) => (v == null || v.isEmpty)
                              ? 'Date is required'
                              : null,
                          onTap: () async {
                            if (controller.startAtController.text.isEmpty) {
                              GlobalService.showAppToast(
                                  message: 'Please select start date');
                            } else {
                              final picked =
                                  await GlobalService.datePickerModal(
                                title: 'Trip End Date',
                                context: context,
                                startTime: DateFormat('dd-MM-yyyy')
                                    .parse(controller.startAtController.text),
                              );
                              if (picked != null) {
                                controller.endedAtController.text =
                                    DateFormat('dd-MM-yyyy').format(picked);
                              }
                            }
                          },
                        ),
                      ],
                    ),

                    // ── Truck ─────────────────────────────────────────────
                    RequiredLabel(label: 'Truck Number', required: true),
                    AppDropdownSearch<TruckModel>(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      menuHeight: ScreenUtils.height * 0.45,
                      hint: 'Select Truck',
                      items: controller.arrTruck.toList(),
                      initialValue: controller.truckModel.value,
                      labelBuilder: (truck) => truck.regdNumber!,
                      menuController: controller.truckController,
                      onChanged: (t1) {
                        if (t1?.driverUuid == null) return;
                        controller.truckModel.value.driverUuid = t1?.driverUuid;
                      },
                      validator: (value) {
                        if (value == null || value.regdNumber == null) {
                          return 'Please select your truck.';
                        }
                        return null;
                      },
                    ),

                    // ── Origin company search ─────────────────────────────
                    RequiredLabel(label: 'Origin', required: true),
                    // Obx is not needed here — the outer Obx already rebuilds
                    // the whole tree when any controller Rx changes.
                    AppDropdownSearch<CompanyModel>(
                      hint: 'Search origin company…',
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      width: ScreenUtils.width,
                      menuHeight: 90,
                      menuController: controller.originController,
                      items: controller.originSearchResults.toList(),
                      initialValue: controller.selectedOriginCompany.value,
                      searchState: controller.originSearchState.value,
                      labelBuilder: (company) => company.name ?? '',
                      onSearchChanged: (input) =>
                          controller.onOriginQueryChanged(input),
                      onChanged: (company) =>
                          controller.onOriginSelected(company),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select origin company.';
                        }
                        return null;
                      },
                    ),

                    // ── Destination company search ─────────────────────────
                    RequiredLabel(label: 'Destination', required: true),
                    AppDropdownSearch<CompanyModel>(
                      hint: 'Search destination company…',
                      menuController: controller.destinationController,
                      items: controller.destinationSearchResults.toList(),
                      initialValue: controller.selectedDestinationCompany.value,
                      searchState: controller.destinationSearchState.value,
                      labelBuilder: (company) => company.name ?? '',
                      onSearchChanged: controller.onDestinationQueryChanged,
                      onChanged: (company) =>
                          controller.onDestinationSelected(company),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select destination company.';
                        }
                        return null;
                      },
                    ),

                    RequiredLabel(label: 'Transporter', required: true),
                    AppDropdownSearch<CompanyModel>(
                      menuController: controller.transporterController,
                      hint: 'Search transporter...',
                      items: controller.transporterSearchResults.toList(),
                      initialValue: controller.selectedTransporter.value,
                      searchState: controller.transporterSearchState.value,
                      labelBuilder: (company) => company.name ?? '',
                      onSearchChanged: controller.onTransporterQueryChanged,
                      onChanged: controller.onTransporterSelected,
                      validator: (value) =>
                          value == null ? 'Please select a transporter.' : null,
                    ),

                    RequiredLabel(label: 'Material Type', required: true),
                    AppDropdownSearch<MineralModel>(
                      menuController: controller.mineralController,
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      hint: controller.availableMinerals.isEmpty
                          ? 'No material found for selected origin'
                          : 'Select material...',
                      enableSearch: controller.availableMinerals.isNotEmpty,
                      items: controller.availableMinerals.toList(),
                      initialValue: controller.selectedMineral.value,
                      labelBuilder: (m) => (m.name ?? '').toCapitalizedLabel(),
                      onChanged: (m) => controller.selectedMineral.value = m,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select material type.';
                        }
                        return null;
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredLabel(label: 'Trip Status', required: true),
                            AppDropdownSearch<String>(
                              width: ScreenUtils.width * 0.45,
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              hint: 'Trip Status',
                              initialValue: controller.strStatus.value?.name,
                              items: controller.tripStatus
                                  .map((e) => e.name)
                                  .toList(),
                              enableSearch: false,
                              labelBuilder: (s) => s.toCapitalizedLabel(),
                              menuController: controller.statusController,
                              onChanged: (name) {
                                if (name == null) return;
                                final status = EnumTripStatus.values
                                    .firstWhereOrNull((e) => e.name == name);
                                if (status != null) {
                                  controller.strStatus.value = status;
                                }
                              },
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Please select trip status'
                                      : null,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredLabel(label: 'TP No', required: true),
                            TextInputField(
                              width: ScreenUtils.width * 0.44,
                              inputFormatters: [],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              nextActionType: TextInputAction.next,
                              controller: controller.tpNoController,
                              validateField: (v) => (v == null || v.isEmpty)
                                  ? 'Enter your TP No'
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredLabel(
                                label: 'Total Weight', required: true),
                            TextInputField(
                              width: ScreenUtils.width * 0.44,
                              hintText: '00.00 in Tonne',
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'(^\d*\.?\d*)'),
                                )
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              nextActionType: TextInputAction.next,
                              controller: controller.totalWeightController,
                              validateField: (v) => (v == null || v.isEmpty)
                                  ? 'Please select weight'
                                  : null,
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              nextActionType: TextInputAction.next,
                              controller: controller.shortWeightController,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // ── Rate ─────────────────────────────────────────────
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
