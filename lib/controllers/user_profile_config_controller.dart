import 'dart:async';
import 'dart:io';

import '/controllers/image_upload_controller.dart';
import '/services/api_end_point.dart';

import '/dist/app_enums.dart';
import '/routes/app_route.dart';
import '/services/db_service.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';
import '/services/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileConfigController extends ImageUploadController {
  final DBService dbService = DBService();
  final PrefUtils prefUtils = PrefUtils();
  final DioService dioService = DioService();

  final TextEditingController aHouseCtrl = TextEditingController();
  final TextEditingController aLocalityCtrl = TextEditingController();
  final TextEditingController aCityCtrl = TextEditingController();
  final TextEditingController aStreetCtrl = TextEditingController();
  final TextEditingController aDistrictCtrl = TextEditingController();
  final TextEditingController aStateCtrl = TextEditingController();
  final TextEditingController aCountryCtrl = TextEditingController();
  final TextEditingController aPincodeCtrl = TextEditingController();

  DateTime pickedDate = DateTime.now();

  // File? selectedImg;
  final ImagePicker _picker = ImagePicker();

  RxInt selectedIndex = (-1).obs;

  // Rx<double> uploadPrgs = 0.0.obs;

  Rx<UploadStatus> status = UploadStatus.initial.obs;

  // Rx<String> imgName = ''.obs;

  Map<String, dynamic> roleObj = {};

  final List<Map<String, dynamic>> userRoleList = [
    {
      "role_id": 6,
      "label": "Truck Owner",
    },
    {
      "role_id": 8,
      "label": "Driver",
    },
  ];
  /*
   ========================================
   ||               SET ROLE             ||
   ========================================
   */

  Future<void> setRole() async {}

  Map<String, dynamic> selectAddress(int index) {
    selectedIndex.value = index;
    return userRoleList[index];
  }

  /*
   ========================================
   ||             IMAGE UPLOAD           ||
   ========================================
   */
  Future<void> uploadImage() async {}

  @override
  Future<void> pickImage({required PickerType pickertype}) async {
    // _status = UploadStatus.initial;
    try {
      XFile? pickedImg;
      if (PickerType.gallery == pickertype) {
        pickedImg = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 200,
          maxWidth: 200,
          // imageQuality: 60,
        );
      } else if (PickerType.camera == pickertype) {
        pickedImg = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 200,
          maxWidth: 200,
          // imageQuality: 60,
        );
      }

      if (pickedImg == null) {
        status.value = UploadStatus.failure;
        GlobalService.printHandler("Error while picking");
      }
      selectedImg = File(pickedImg!.path);
      status.value = UploadStatus.uploading;
      uploadPrgs.value = 0.0;
      imgName.value = pickedImg.name;
      simulateUpload();
    } catch (e) {
      status.value = UploadStatus.failure;
      GlobalService.printHandler('Failure: $e');
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
      if (uploadPrgs.value >= 1.0) {
        timer.cancel();
        status.value = UploadStatus.success;
      } else {
        uploadPrgs.value += 0.05;
        if (uploadPrgs.value > 1.0) uploadPrgs.value = 1.0;
      }
    });
  }

  void reset() {
    selectedImg = null;
    uploadPrgs.value = 0.0;
    status.value = UploadStatus.initial;
  }

  /*
   ========================================
   ||           ADDRESS UPLOAD           ||
   ========================================
   */
  Future<void> addAddress({
    // required String token,
    required String txtHouse,
    required String txtLocality,
    required String txtStreet,
    required String txtCity,
    required String txtPincode,
    required String txtDist,
    required String txtState,
    required String txtCountry,
  }) async {
    GlobalService.closeKeyboard();
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    Map<String, dynamic> bodyObj = {
      'house_no': txtHouse,
      'locality': txtLocality,
      'city': txtCity,
      'street': txtStreet,
      'district': txtDist,
      'state': txtState,
      'pin_code': txtPincode,
      'country': txtCountry
    };
    GlobalService.showProgress();
    ApiResponse response =
        await dioService.post(ApiEndPoint.apiAddAddress, body: bodyObj);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 201:
        Get.offAndToNamed(AppRoute.imageAuth);
        break;
      case 401:
        break;
      default:
    }
  }
}
