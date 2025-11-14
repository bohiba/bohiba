import 'dart:io';
import '/dist/app_enums.dart';
import '/services/truck_service.dart';
import '/services/global_service.dart';
import '/services/permission_service.dart';
import '/controllers/image_upload_controller.dart';
import '/model/truck_model.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class TruckController extends ImageUploadController {
  final RefreshController refreshTruckPage =
      RefreshController(initialRefresh: false);
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImg;

  Rx<UploadStatus> status = UploadStatus.initial.obs;
  Rxn<TruckModel> truckModel = Rxn<TruckModel>();

  RxBool isDriverAssigned = false.obs;

  RxString strErrorDes = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var truckId = Get.arguments;
    Future.delayed(Duration.zero, () async {
      await getTruckInfo(truckFetchValue: truckId);
    });
  }

  Future<void> onRefreshTruckPage() async {
    if (truckModel.value?.id != null) {
      await getTruckInfo(
        truckFetchValue: truckModel.value!.regdNumber!,
        methodType: MethodType.api,
      );
      refreshTruckPage.refreshCompleted();
    }
  }

  Future<void> setImage() async {
    TruckModel? model;
    if (selectedImg.value != null) {
      model = await TruckService.setTruckImage(
          oldTruck: truckModel.value,
          imagePath: pickedImg!.path,
          imageFile: [File(pickedImg!.path)]);
    }

    if (model != null) {
      truckModel.value = model;
    }
  }

  Future<TruckModel?> getTruckInfo({
    required var truckFetchValue,
    MethodType methodType = MethodType.local,
    int fetchType = 0,
  }) async {
    TruckModel? truck = await TruckService.getTruck(
        value: truckFetchValue, methodType: methodType, type: fetchType);
    if (truck != null) {
      truckModel.value = truck;
      update();
    } else {
      strErrorDes.value =
          'Sorry we unable to find your truck, Make sure truck is added with your account.';
    }
    isDriverAssigned.value =
        truckModel.value?.driverUuid == null ? false : true;
    return truck;
  }

  Future<int> removeDriver() async {
    int success = await TruckService.removeDriver(oldTruck: truckModel.value!);
    if (success > 0) {
      TruckModel? updatedTruck =
          await TruckService.getTruck(value: truckModel.value?.id!);
      if (updatedTruck != null) {
        truckModel.value = updatedTruck;
        isDriverAssigned.value = false;
      }
    }
    return success;
  }

  Future<int> deleteTruck({required int truckId}) async {
    int success = await TruckService.deleteTruck(truckId: truckId);
    return success;
  }

  @override
  void deleteImageFile(File file) async {
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
          description:
              'Bohiba need file permission to select image by you! Please `Allow access` to access',
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
}
