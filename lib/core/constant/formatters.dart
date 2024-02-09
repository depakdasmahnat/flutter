import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newText = newValue.text;

    if (newText.length > 2 && newText[0] != '(') {
      newText = '(${newText.substring(0, 3)})${newText.substring(3)}';
    }

    if (newText.length > 5 && newText[5] != ' ') {
      newText = '${newText.substring(0, 5)} ${newText.substring(5)}';
    }
    if (newText.length > 9 && newText[9] != '-') {
      newText = '${newText.substring(0, 9)}-${newText.substring(9)}';
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
