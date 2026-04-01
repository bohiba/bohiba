import 'dart:io';

import '../dist/enums/app_enums.dart';
import 'package:get/get.dart';

abstract class ImageUploadController extends GetxController {
  Rx<double> uploadPrgs = 0.0.obs; // Progress (0.0 - 1.0)
  Rx<String> imgName = ''.obs;
  Rx<File?> selectedImg = Rx<File?>(null);

  RxDouble scale = 1.0.obs;
  RxDouble offsetX = 0.0.obs;
  RxDouble offsetY = 0.0.obs;

  Future<void> pickImage({required PickerType pickertype});

  void simulateUpload() {}

  void deleteImageFile(File file);
}
