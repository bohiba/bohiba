import 'dart:io';

import '/dist/app_enums.dart';
import 'package:get/get.dart';

abstract class ImageUploadController extends GetxController {
  Rx<double> uploadPrgs = 0.0.obs; // Progress (0.0 - 1.0)
  Rx<String> imgName = ''.obs;
  File? selectedImg;

  Future<void> pickImage({required PickerType pickertype});

  void simulateUpload() {}

  void deleteImageFile(File file);
}
