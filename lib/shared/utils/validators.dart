class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Informe o e-mail';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return 'E-mail inválido';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? cnpj(String? value) {
    if (value == null || value.length < 14) return 'CNPJ inválido';
    return null;
  }
}
