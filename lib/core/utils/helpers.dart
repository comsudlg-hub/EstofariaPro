// Funções auxiliares diversas
import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double value) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatter.format(value);
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String generateRandomId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
