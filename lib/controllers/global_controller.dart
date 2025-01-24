import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class GlobalController extends GetxController {
  XFile imageFile = XFile("");
  String base64Image = "";

  Future<String> pickDate(
      {required DateFormat dateFormatter, required String hintText}) async {
    DateTime? chooseDate = DateTime.now();
    DateFormat dateFormat = dateFormatter;
    BuildContext buildContext = Get.context!;
    chooseDate = await showDatePicker(
        context: buildContext,
        firstDate: DateTime(1820),
        lastDate: DateTime.now(),
        helpText: hintText,
        fieldHintText: 'DD-MM-YYYY',
        fieldLabelText: '',
        keyboardType: TextInputType.numberWithOptions());
    if (chooseDate != null) {
      return dateFormat.format(chooseDate);
    } else {
      chooseDate = DateTime.now();
      return dateFormat.format(chooseDate);
    }
  }

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
