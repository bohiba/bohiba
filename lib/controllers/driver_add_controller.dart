import 'dart:async';
import 'dart:io';

import '/controllers/image_upload_controller.dart';
import '/model/driver_model.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';

import '/dist/app_enums.dart';
import '/model/truck_model.dart';
import '/services/db_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';
import '/services/ocr_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DriverAddController extends ImageUploadController {
  DBService dBService = DBService();
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

  Future<void> addDriver(
      {required Map<String, dynamic> bodyMap, String truckNo = ''}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.closeKeyboard();
    if (bodyMap['type'] == 0) {
      GlobalService.getAlertDialog(
        status: AlertStatus.info,
        title: 'Feature Not Yet Supported',
        description:
            'Currently this feature is not support. We are working on it. Please try using `UUID`.',
      );
      return;
    }
    GlobalService.showProgress();
    ApiResponse response =
        await dioService.post(ApiEndPoint.apiAddDriver, body: bodyMap);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> dataObj = Map.from(response.data);
        int addDriverSucess = await getDriver(id: "${dataObj['id']}");
        if (addDriverSucess > 0) {
          GlobalService.showAppToast(message: response.message);
          Get.back(result: true);
        } else {
          GlobalService.showAppToast(message: 'Failed to add driver');
        }
        break;
      case 401:
        GlobalService.getAlertDialog(
          status: AlertStatus.warning,
          title: 'Failed',
          description: response.message,
        );
        break;
      default:
    }
  }

  Future<int> getDriver({required String id}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response =
        await dioService.get('${ApiEndPoint.apiGetDriver}/$id');
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        DriverModel updatedriver = DriverModel.fromJson(response.data);
        int dbSucess =
            await dBService.putData<DriverModel>(tblDriver, id, updatedriver);
        return dbSucess;
      case 401:
        GlobalService.showAppToast(message: response.message);
        return 0;
      default:
        return 0;
    }
  }

  Future<List<TruckModel>> getTruckList() async {
    arrTruck.clear();
    List<TruckModel> truckList = await dBService.getAllData(tblTrucks);
    arrTruck.addAll(truckList);
    arrTruck.refresh();
    return truckList;
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
      selectedImg = File(pickedImg.path);
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
        selectedImg = null;
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
