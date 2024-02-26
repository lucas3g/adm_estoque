import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formatters {}

extension FormatDecimal on double {
  String formatDecimal() {
    final NumberFormat format = NumberFormat('###,###,##0.00', 'pt_BR');

    return format.format(this).toString();
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
