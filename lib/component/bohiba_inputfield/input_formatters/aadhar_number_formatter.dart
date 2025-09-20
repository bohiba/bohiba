import 'package:flutter/services.dart';

class AadhaarNumberFormatter extends TextInputFormatter {
  static const int groupSize = 4;
  static const int maxDigits = 16;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length > maxDigits) {
      digitsOnly = digitsOnly.substring(0, maxDigits);
    }

    final buffer = StringBuffer();
    int selectionIndex = newValue.selection.baseOffset;

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % groupSize == 0) {
        buffer.write('-');
        if (i < selectionIndex) {
          selectionIndex++;
        }
      }
      buffer.write(digitsOnly[i]);
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: selectionIndex.clamp(0, formattedText.length),
      ),
    );
  }
}
