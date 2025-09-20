import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DocumentAuthProvider extends GetxController {
  final TextEditingController _dlNoController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  TextEditingController get dlNoController => _dlNoController;
  TextEditingController get dobController => _dobController;
  // DateTime eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);
  Future<String> pickDate({
    required BuildContext context,
    required String dateFormatter,
    required String hintText,
  }) async {
    DateTime? chooseDate = DateTime.now();
    DateFormat dateFormat = DateFormat(dateFormatter);

    chooseDate = await showDatePicker(
        context: context,
        initialDate:
            DateTime(chooseDate.year - 20, chooseDate.month, chooseDate.day),
        firstDate: DateTime(1820),
        lastDate:
            DateTime(chooseDate.year - 20, chooseDate.month, chooseDate.day),
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
}
