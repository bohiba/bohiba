import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GlobalController extends GetxController {
  XFile imageFile = XFile("");
  String base64Image = "";

  Future<String> decodeBase64ToImage(String imagePath) async {
    File imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      throw Exception("Image file not found");
    }
    List<int> imageBytes = await imageFile.readAsBytes();
    base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> pickImage() async {
    try {
      XFile? selected =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (selected != null) {
        imageFile = selected;
        update();
        decodeBase64ToImage(imageFile.path);
      } else {
        debugPrint("\n============\n| Pick an image. |\n============\n");
      }
    } catch (e) {
      debugPrint(
          "\n===========\n|Error while picking image: $e|\n===========\n");
    }
  }

  String removeBlankSpace(String value) {
    String stringWithoutSpaces = value.replaceAll(' ', '');
    return stringWithoutSpaces;
  }

  void closeKeyboard() {
    FocusScope.of(Get.context!).unfocus();
  }

  void openKeyBoard() {
    FocusScope.of(Get.context!).requestFocus();
  }
}
