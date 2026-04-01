import 'dart:async';
import 'dart:io';

import '../dist/enums/app_enums.dart';
import '/model/truck_model.dart';
import '../model/user_model.dart';
import '/services/dio_serivce.dart';
import '/services/truck_service.dart';
import '/services/driver_service.dart';
import '/services/global_service.dart';
import '/services/ocr_services.dart';
import '/controllers/image_upload_controller.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DriverAddController extends ImageUploadController {
  // DBService dBService = DBService();

  DioService dioService = DioService();
  OcrService ocrService = OcrService();

  final TextEditingController uuidCtlr = TextEditingController();
  final TextEditingController assignTruckCtlr = TextEditingController();
  final TextEditingController licenseCtrl = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Rx<AddAssetUsing> addAsset = AddAssetUsing.uuid.obs;
  Rx<UploadStatus> status = UploadStatus.initial.obs;

  Rx<bool> isAnalysing = false.obs;
  Rx<bool> popResult = false.obs;

  Rx<String> strTruckRegdNo = ''.obs;
  Rx<String> scannedDL = ''.obs;
  Rx<String> imagePath = ''.obs;

  RxList<TruckModel> arrTruck = <TruckModel>[].obs;

  Rx<TruckModel> truck = TruckModel().obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await getTruckList();
    });
  }

  Future<UserModel?> addDriver({String? truckNo}) async {
    final isUuidFlow = addAsset.value == AddAssetUsing.uuid;
    final isDocFlow = addAsset.value == AddAssetUsing.doc;

    Map<String, dynamic> bodyObj = {};
    if (isUuidFlow) {
      final uuid = uuidCtlr.text.trim();

      if (uuid.isEmpty) {
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Driver',
          desc: 'Please provide driver UUID',
        );
        return null;
      }

      if (uuid.length != 6) {
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Driver',
          desc: 'Please provide valid UUID',
        );
        return null;
      }

      bodyObj = {
        'driver_uuid': uuid,
        'type': 1,
      };
    }

    if (isDocFlow) {
      final dl = licenseCtrl.text.trim();
      final dob = dateController.text.trim();

      if (dl.isEmpty) {
        GlobalService.showAppToast(message: 'Please provide driver DL Number');
        return null;
      }
      if (dl.length != 16) {
        GlobalService.showAppToast(message: 'Please provide valid DL Number');
        return null;
      }
      if (dob.isEmpty) {
        GlobalService.showAppToast(message: 'Please provide D.O.B');
        return null;
      }

      bodyObj = {
        'license_number': dl,
        'dob': dob,
        'type': 0,
      };
    }

    if (bodyObj.isNotEmpty) {
      UserModel? driver = await DriverService.createDriver(bodyObj: bodyObj, vehcileNumber: truckNo);
      if (driver != null) {
        truckNo = null;
        licenseCtrl.clear();
        dateController.clear();
        uuidCtlr.clear();
        popResult.value = true;
        strTruckRegdNo.value = '';
        truck.value = TruckModel();
      }
      return driver;
    }
    return null;
  }

  Future<void> getTruckList() async {
    arrTruck.clear();
    List<TruckModel>? truckList = await TruckService.getTruckList();
    if (truckList != null) {
      arrTruck.addAll(truckList);
      arrTruck.refresh();
    }
  }

  @override
  Future<void> pickImage({required PickerType pickertype}) async {
    try {
      XFile? pickedImg;
      if (PickerType.gallery == pickertype) {
        pickedImg = await _picker.pickImage(source: ImageSource.gallery);
      } else if (PickerType.camera == pickertype) {
        pickedImg = await _picker.pickImage(source: ImageSource.camera);
      }

      if (pickedImg == null) {
        status.value = UploadStatus.failure;
        GlobalService.printHandler("Error while picking");
        return;
      }
      selectedImg.value = File(pickedImg.path);
      status.value = UploadStatus.uploading;
      uploadPrgs.value = 0.0;
      imagePath.value = pickedImg.path;
      imgName.value = pickedImg.name;
      simulateUpload();
      isAnalysing.value = true;
      // scannedDL.value = await OcrService.getTextFromImage(imagePath.value);
      uploadPrgs.value = 1.0;
      if (scannedDL.toLowerCase().contains('licence')) {
        status.value = UploadStatus.verified;
      } else {
        status.value = UploadStatus.failure;
      }
      OcrService.dispose();
      GlobalService.printHandler(scannedDL.value);
    } catch (e) {
      GlobalService.printHandler('Failure: $e');
    } finally {
      isAnalysing.value = false;
    }
  }

  @override
  Future<void> deleteImageFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        selectedImg;
        status.value = UploadStatus.initial;
        GlobalService.printHandler('File deleted successfully.');
      } else {
        GlobalService.printHandler('File does not exist.');
      }
    } catch (e) {
      status.value = UploadStatus.failure;
      GlobalService.printHandler('Error deleting file: $e');
    }
  }

  @override
  void simulateUpload() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (uploadPrgs.value >= 0.9) {
        timer.cancel();
        // status.value = UploadStatus.success;
      } else {
        uploadPrgs.value += 0.05;
        if (uploadPrgs.value > 1.0) uploadPrgs.value = 1.0;
      }
    });
    super.simulateUpload();
  }

  @override
  void dispose() {
    OcrService.dispose();
    super.dispose();
  }
}
