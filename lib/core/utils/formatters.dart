import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formata/mascara campos: CPF, CNPJ, telefone, CEP e moeda.
/// Uso: inputFormatters: [Formatters.cnpj()]
class Formatters {
  static TextInputFormatter cpf() => _CpfInputFormatter();
  static TextInputFormatter cnpj() => _CnpjInputFormatter();
  static TextInputFormatter phone() => _PhoneInputFormatter();
  static TextInputFormatter cep() => _CepInputFormatter();
  static TextInputFormatter currencyDigitsOnly() =>
      FilteringTextInputFormatter.digitsOnly;

  static String formatCpf(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return value;
    return "${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9)}";
  }

  static String formatCnpj(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 14) return value;
    return "${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}-${digits.substring(12)}";
  }

  static String formatPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11) {
      return "(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}";
    } else if (digits.length == 10) {
      return "(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}";
    }
    return value;
  }

  static String formatCep(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) return value;
    return "${digits.substring(0, 5)}-${digits.substring(5)}";
  }

  static String formatCurrencyFromCents(String centsValue) {
    final number = double.tryParse(centsValue) ?? 0.0;
    final formatter = NumberFormat.simpleCurrency(locale: "pt_BR");
    return formatter.format(number / 100);
  }
}

/// --- Implementações privadas (máscaras em tempo real) ---

class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) digits = digits.substring(0, 11);

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 14) digits = digits.substring(0, 14);

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5) buffer.write('.');
      if (i == 8) buffer.write('/');
      if (i == 12) buffer.write('-');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) digits = digits.substring(0, 11);

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      if (digits.length > 10) {
        if (i == 7) buffer.write('-');
      } else {
        if (i == 6) buffer.write('-');
      }
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 5) buffer.write('-');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
