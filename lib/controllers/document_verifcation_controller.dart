import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DocumentVerificationController extends GetxController {
  File? img;

  Future<File?> imagePicker() async {
    try {
      XFile? image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 25);

      if (image == null) {
        return null;
      } else {
        return img = File(image.path);
      }
    } on PlatformException catch (e) {
      printError(info: 'Failed to pick image: $e');
    }
    return null;
  }
}
