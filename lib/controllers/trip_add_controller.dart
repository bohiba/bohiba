import 'dart:io';

import '/services/global_service.dart';

import '/extensions/bohiba_extension.dart';
import '/services/trip_service.dart';

import '/controllers/image_upload_controller.dart';
import '/dist/app_enums.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/services/db_service.dart';
import '/services/dio_serivce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

class TripAddController extends ImageUploadController {
  DioService dioService = DioService();
  DBService dBService = DBService();

  TripModel? tripModel;
  Rx<TruckModel> truckModel = TruckModel().obs;
  RxList<TruckModel> arrTruck = <TruckModel>[].obs;
  RxList<TruckModel> arrDoc = <TruckModel>[].obs;

  TextEditingController startAtController = TextEditingController();
  TextEditingController endedAtController = TextEditingController();
  TextEditingController truckController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
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
    'In Transit',
    'Completed',
    'Unloading',
    'Delayed',
    'Cancelled',
    'On Hold',
    'Reassigned',
    'Other',
  ];
  final List<String> ironOreTypes = [
    'Iron Ore (Lumps)',
    'Iron Ore (Fines)',
    'Pellets',
    'Blue Dust',
    'Sinter Feed',
    'Manganese Ore',
    'Laterite',
    'Slurry (Pipelines)',
  ];

  DateTime pickedDate = DateTime.now();

  // Document
  Rx<UploadStatus> status = UploadStatus.initial.obs;

  @override
  void onInit() {
    super.onInit();
    tripModel = Get.arguments;

    Future.delayed(Duration.zero, () async {
      if (tripModel != null) {
        await editTripController();
      }
      await getTruckList();
    });
  }

  Future<void> addUpdateTrip() async {
    if (truckController.text.isEmpty) {
      GlobalService.showAppToast(message: 'Please select a truck');
      return;
    }

    String tripCode1 = (truckController.text
        .trim()
        .toString()
        .substring(2, truckController.text.length - 4));
    String tripCode2 = (startAtController.text.trim().replaceAll('-', ''));
    String rateTrip =
        rateController.text.replaceAll(RegExp(r'[₹,]'), '').trim();
    String statusTrip =
        statusController.text.trim().toLowerCase().replaceAll(' ', '_');

    Map<String, dynamic> bodyObj = {
      'trip_code': tripCode1 + tripCode2,
      'started_at': startAtController.text.trim(),
      'ended_at': endedAtController.text.trim(),
      'regd_number': truckController.text.trim(),
      'driver_uuid': truckModel.value.driver?.uuid,
      'origin': originController.text.trim(),
      'destination': destinationController.text.trim(),
      'material_type': materialController.text.trim(),
      'trip_status': statusTrip,
      'load_weight': totalWeightController.text.trim(),
      'short_weight': shortWeightController.text.trim(),
      'rate': rateTrip,
    };
    if (tripModel == null) {
      int addSucess = await TripService.addTrip(
          bodyMap: bodyObj, truckModel: truckModel.value);
      if (addSucess > 0) {
        Get.back(result: true);
      }
    } else {
      int addSucess = await TripService.updateTrip(
        bodyMap: bodyObj,
        tripId: tripModel!.id!,
      );
      if (addSucess > 0) {
        Get.back(result: true);
      }
    }
  }

  Future<List<TruckModel>> getTruckList() async {
    arrTruck.clear();
    List<TruckModel> truckList = await dBService.getAllData(tblTrucks);
    arrTruck.addAll(truckList);
    return truckList;
  }

  void clearController() {
    startAtController.clear();
    endedAtController.clear();
    truckController.clear();
    originController.clear();
    destinationController.clear();
    materialController.clear();
    statusController.clear();
    totalWeightController.clear();
    shortWeightController.clear();
    rateController = MoneyMaskedTextController(
      initialValue: 00.00,
      precision: 2,
      leftSymbol: "₹",
      decimalSeparator: ".",
      thousandSeparator: ",",
    );
  }

  Future<void> editTripController() async {
    // truckModel.value =
    //     await TruckService.getTruck(truckId: tripModel!.truck!.id!) ??
    //         TruckModel();

    startAtController.text = tripModel?.startDate ?? '';
    endedAtController.text = tripModel?.endedDate ?? '';
    truckController.text = tripModel?.truck?.regdNumber ?? '';
    originController.text = tripModel?.origin ?? '';
    destinationController.text = tripModel?.destination ?? '';
    materialController.text =
        tripModel?.loadDetail?.materialType?.toCapitalizedLabel() ?? '';
    statusController.text = tripModel?.tripStatus?.toCapitalizedLabel() ?? '';
    totalWeightController.text =
        tripModel?.loadDetail?.loadWeight.toString() ?? '';
    shortWeightController.text =
        tripModel?.loadDetail?.shortWeight.toString() ?? '';
    rateController = MoneyMaskedTextController(
      initialValue: tripModel?.loadDetail?.rate ?? 0.0,
      precision: 2,
      leftSymbol: "₹",
      decimalSeparator: ".",
      thousandSeparator: ",",
    );
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
