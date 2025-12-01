import 'dart:async';
import 'dart:io';

import '/controllers/image_upload_controller.dart';
import '/dist/app_enums.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/services/global_service.dart';
import '/services/permission_service.dart';
import '/services/trip_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddTripDocumentController extends ImageUploadController {
  Rx<UploadStatus> status = UploadStatus.initial.obs;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImg;

  // Document
  Rxn<TripModel> trip = Rxn<TripModel>();
  RxList<TruckModel> arrDoc = <TruckModel>[].obs;

  @override
  void onInit() {
    trip.value = Get.arguments;
    super.onInit();
  }

  Future<int> addDocument() async {
    Map<String, dynamic> bodyMap = {"trip_id": trip.value?.id, "doc_type": pickedImg?.path};
    int success = await TripService.addDocument(bodyObj: bodyMap, imageList: [
      File(pickedImg!.path),
    ]);
    return success;
  }

  @override
  Future<void> deleteImageFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        selectedImg.value = null;
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
  Future<void> pickImage({required PickerType pickertype}) async {
    try {
      bool isGranted = await PermissionService.requestCamPermission();
      if (!isGranted) {
        GlobalService.showAlertDialog(
          status: AlertStatus.info,
          title: 'Permission',
          description: 'Bohiba need file permission to select image by you! Please `Allow access` to access',
          discardBtnTxt: 'Deny',
          saveBtnTxt: 'Allow',
          onSave: () async {
            Get.back();
            await PermissionService.requestOpenAppSetting();
          },
        );
        return;
      }
      if (PickerType.gallery == pickertype) {
        pickedImg = await _picker.pickImage(
          source: ImageSource.gallery,
          // imageQuality: 60,
        );
      } else if (PickerType.camera == pickertype) {
        pickedImg = await _picker.pickImage(
          source: ImageSource.camera,
          // imageQuality: 60,
        );
      }

      if (pickedImg == null) {
        status.value = UploadStatus.failure;
        GlobalService.printHandler('Please select an image to upload');
        return;
      }
      selectedImg.value = File(pickedImg!.path);
      status.value = UploadStatus.uploading;
      uploadPrgs.value = 0.0;
      imgName.value = pickedImg!.name;
      simulateUpload();
    } catch (e) {
      status.value = UploadStatus.failure;
      GlobalService.showSnackBar(
        status: AlertStatus.failure,
        desc: 'Failed to upload image',
      );
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

  void reset() async {
    selectedImg.value = null;
    uploadPrgs.value = 0.0;
    status.value = UploadStatus.initial;
    if (selectedImg.value != null) {
      if (await selectedImg.value!.exists()) {
        await selectedImg.value!.delete();
        selectedImg.value = null;
        status.value = UploadStatus.initial;
        GlobalService.printHandler('File deleted successfully.');
      }
    }
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }
}
