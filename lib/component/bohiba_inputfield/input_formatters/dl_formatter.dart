import 'package:flutter/services.dart';

class DrivingLicenseInputFormatter extends TextInputFormatter {
  static const _maxLength = 16;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-alphanumeric characters
    final rawText =
        newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();

    final buffer = StringBuffer();
    int selectionIndex = newValue.selection.baseOffset;
    int usedHyphens = 0;

    for (int i = 0; i < rawText.length && buffer.length < _maxLength; i++) {
      buffer.write(rawText[i]);

      // Insert hyphen at position 2, 4, and 8
      if ((i == 1 || i == 3 || i == 7) && i != rawText.length - 1) {
        buffer.write('-');
        if (i < selectionIndex) {
          usedHyphens++;
        }
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: (selectionIndex + usedHyphens).clamp(0, buffer.length),
      ),
    );
  }
}
