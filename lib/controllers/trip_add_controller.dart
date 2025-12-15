import 'dart:io';
import '/extensions/bohiba_extension.dart';

import '/controllers/image_upload_controller.dart';
import '/dist/app_enums.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';

import '/services/dio_serivce.dart';
import '/services/trip_service.dart';
import '/services/truck_service.dart';
import '/services/global_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

class TripAddController extends ImageUploadController {
  DioService dioService = DioService();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> startDateKey = GlobalKey<FormFieldState<String>>();

  Rxn<TripModel> tripModel = Rxn<TripModel>();
  Rx<TruckModel> truckModel = TruckModel().obs;
  RxList<TruckModel> arrTruck = <TruckModel>[].obs;

  TextEditingController startAtController = TextEditingController();
  TextEditingController endedAtController = TextEditingController();
  TextEditingController truckController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController transporterController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController totalWeightController = TextEditingController();
  TextEditingController shortWeightController = TextEditingController();
  MoneyMaskedTextController rateController = MoneyMaskedTextController(
    initialValue: 00.00,
    precision: 2,
    leftSymbol: "₹",
    decimalSeparator: ".",
    thousandSeparator: ",",
  );

  final List<String> tripStatus = [
    'in_transit',
    'completed',
    'unloading',
    'delayed',
    'cancelled',
    'on_hold',
    'reassigned',
    'other',
  ];

  List<String> ironOreTypes = [
    "bauxite",
    "basalt",
    "chromite",
    "clay",
    "coal",
    "copper_ore",
    "dolomite",
    "feldspar",
    "galena_lead_ore",
    "gold_ore",
    "granite",
    "gypsum",
    "ilmenite",
    "iron_ore",
    "laterite",
    "limestone",
    "lignite",
    "manganese_ore",
    "marble",
    "monazite",
    "nickel_ore",
    "platinum_ore",
    "quartz",
    "rare_earth_ore",
    "rutile",
    "silica_sand",
    "sphalerite_zinc_ore",
    "tin_ore",
    "uranium_ore"
  ];

  DateTime pickedDate = DateTime.now();

  Rx<String> strOre = "".obs;
  Rx<String> strStatus = "".obs;

  RxInt countUpdate = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tripModel.value = Get.arguments;

    Future.delayed(Duration.zero, () async {
      await getTruckList();
      if (tripModel.value != null) {
        await editTripController();
      }
    });
  }

  Future<int> addUpdateTrip() async {
    if (!globalKey.currentState!.validate()) {
      return 0;
    }

    String tripCode1 = (truckController.text.trim().toString().substring(2, truckController.text.length - 4));
    String tripCode2 = (startAtController.text.trim().replaceAll('-', ''));
    String rateTrip = rateController.text.replaceAll(RegExp(r'[₹,]'), '').trim();
    String statusTrip = statusController.text.trim().toLowerCase().replaceAll(' ', '_');

    Map<String, dynamic> bodyObj = {
      'trip_code': tripCode1 + tripCode2,
      'started_at': startAtController.text.trim(),
      'ended_at': endedAtController.text.trim(),
      'transporter': transporterController.text.trim().replaceAll(' ', '_').toLowerCase(),
      'regd_number': truckController.text.trim(),
      'driver_uuid': truckModel.value.driverUuid,
      'origin': originController.text.trim().toLowerCase(),
      'destination': destinationController.text.trim().toLowerCase(),
      'material_type': materialController.text.replaceAll(' ', '_').toLowerCase(),
      'trip_status': statusTrip,
      'load_weight': totalWeightController.text.trim(),
      'short_weight': shortWeightController.text.trim(),
      'rate': rateTrip,
    };
    int addOrUpdateSucess = 0;
    if (tripModel.value == null) {
      addOrUpdateSucess = await TripService.addTrip(bodyMap: bodyObj, truckModel: truckModel.value);
      if (addOrUpdateSucess > 0) {
        countUpdate++;
        clearController();
      }
    } else {
      addOrUpdateSucess = await TripService.updateTrip(
        bodyMap: bodyObj,
        trip: tripModel.value!,
      );
      if (addOrUpdateSucess > 0) {
        countUpdate++;
        clearController();
      }
    }
    return addOrUpdateSucess;
  }

  Future<void> getTruckList() async {
    List<TruckModel>? truckList = await TruckService.getTruckList();
    if (truckList != null) {
      arrTruck.clear();
      arrTruck.addAll(truckList);
    }
  }

  void clearController() {
    startAtController.clear();
    endedAtController.clear();
    transporterController.clear();
    truckController.clear();
    originController.clear();
    destinationController.clear();
    materialController.clear();
    statusController.clear();
    totalWeightController.clear();
    shortWeightController.clear();
    rateController.updateValue(0.0);
  }

  Future<void> editTripController() async {
    startAtController.text = tripModel.value?.startDate ?? '';
    endedAtController.text = tripModel.value?.endedDate ?? '';
    transporterController.text = tripModel.value?.transporter?.toCapitalizedLabel() ?? '';
    truckController.text = tripModel.value?.truck?.regdNumber ?? '';
    originController.text = tripModel.value?.origin?.toUpperCase() ?? '';
    destinationController.text = tripModel.value?.destination?.toUpperCase() ?? '';
    materialController.text = tripModel.value?.loadDetail?.materialType?.toCapitalizedLabel() ?? '';
    statusController.text = tripModel.value?.tripStatus?.toCapitalizedLabel() ?? '';
    totalWeightController.text = tripModel.value?.loadDetail?.loadWeight.toString() ?? '';
    shortWeightController.text = tripModel.value?.loadDetail?.shortWeight.toString() ?? '';
    rateController = MoneyMaskedTextController(
      initialValue: tripModel.value?.loadDetail?.rate ?? 0.0,
      precision: 2,
      leftSymbol: "₹",
      decimalSeparator: ".",
      thousandSeparator: ",",
    );

    try {
      truckModel.value = arrTruck.firstWhere((truck) => truck.regdNumber == tripModel.value?.truck?.regdNumber);
      strOre.value = ironOreTypes.firstWhere((ore) => ore == tripModel.value?.loadDetail?.materialType);

      strStatus.value = tripStatus.firstWhere((status) => status == tripModel.value?.tripStatus);
    } catch (e) {
      GlobalService.printHandler("$e");
    }
  }

  /*
   ==============================
   ||          Add Document    ||
   ==============================   
   */

  @override
  void deleteImageFile(File file) {}

  @override
  Future<void> pickImage({required PickerType pickertype}) async {}
}
