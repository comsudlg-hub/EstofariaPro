import 'package:flutter/material.dart';

class AppColors {
  // Fundo neutro
  static const Color backgroundLight = Color(0xFFF6F3F0);
  static const Color backgroundDark = Color(0xFF2B2B2B);

  // Paleta couro moderno
  static const Color primary = Color(0xFFB85C38);
  static const Color secondary = Color(0xFFD9BCA3);
  static const Color accent = Color(0xFF6C4F3D);

  // Textos
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textLight = Colors.white;

  // Botões
  static const Gradient buttonGradient = LinearGradient(
    colors: [Color(0xFFD9BCA3), Color(0xFFB85C38)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
