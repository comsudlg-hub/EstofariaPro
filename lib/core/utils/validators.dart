/// Validações completas usadas pelo projeto (IdeiaV1 / Mapa da Mina)
class Validators {
  static String? requiredField(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? "Campo obrigatório";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "E-mail obrigatório";
    }
    final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return "E-mail inválido";
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return "Telefone obrigatório";
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 11) return "Telefone inválido";
    return null;
  }

  static String? cep(String? value) {
    if (value == null || value.trim().isEmpty) return "CEP obrigatório";
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) return "CEP inválido";
    return null;
  }

  // CPF com cálculo dos dígitos verificadores
  static String? cpf(String? value) {
    if (value == null || value.trim().isEmpty) return "CPF obrigatório";

    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return "CPF deve ter 11 dígitos";
    if (RegExp(r'^(\d)\1*$').hasMatch(digits)) return "CPF inválido";

    final nums = digits.split('').map(int.parse).toList();

    for (int j = 9; j < 11; j++) {
      int sum = 0;
      for (int i = 0; i < j; i++) {
        sum += nums[i] * ((j + 1) - i);
      }
      int mod = (sum * 10) % 11;
      if (mod == 10) mod = 0;
      if (nums[j] != mod) return "CPF inválido";
    }
    return null;
  }

  // CNPJ com cálculo dos dígitos verificadores (completo)
  static String? cnpj(String? value) {
    if (value == null || value.trim().isEmpty) return "CNPJ obrigatório";

    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 14) return "CNPJ deve ter 14 dígitos";
    if (RegExp(r'^(\d)\1*$').hasMatch(digits)) return "CNPJ inválido";

    List<int> numbers = digits.split('').map(int.parse).toList();

    int calcDigit(List<int> base, List<int> multipliers) {
      int sum = 0;
      for (int i = 0; i < multipliers.length; i++) {
        sum += base[i] * multipliers[i];
      }
      int mod = sum % 11;
      return mod < 2 ? 0 : 11 - mod;
    }

    int d1 = calcDigit(
        numbers.sublist(0, 12), [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);
    int d2 = calcDigit(
        numbers.sublist(0, 12) + [d1], [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);

    if (numbers[12] != d1 || numbers[13] != d2) return "CNPJ inválido";
    return null;
  }

  static String? password(String? value, {int minLen = 6}) {
    if (value == null || value.isEmpty) return "Senha obrigatória";
    if (value.length < minLen) return "Mínimo $minLen caracteres";
    return null;
  }

  /// Novo validador: número
  static String? number(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? "Campo obrigatório";
    }
    if (double.tryParse(value.trim()) == null) {
      return message ?? "Digite um número válido";
    }
    return null;
  }
}
