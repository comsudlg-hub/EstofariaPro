/// Tipografia Roboto - EstofariaPro
/// Hierarquia clara: Bold para títulos, Regular para textos.
library estofariapro_typography;

import 'package:flutter/material.dart';

class EstofariaTextStyles {
  // Títulos Grandes (Dashboards, Splash)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700, // Bold
    fontSize: 32.0,
    height: 1.2,
  );

  // Títulos de Seção (Cartões, Formulários)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700, // Bold
    fontSize: 24.0,
    height: 1.3,
  );

  // Títulos Médios (Subtítulos)
  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 20.0,
    height: 1.4,
  );

  // Texto de Corpo Principal (Descrições, Campos)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 16.0,
    height: 1.5,
  );

  // Texto Secundário (Labels, Informações menores)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 14.0,
    height: 1.5,
  );

  // Texto Pequeno (Captions, Dicas)
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w300, // Light
    fontSize: 12.0,
    height: 1.5,
  );

  // Botões
  static const TextStyle button = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500, // Medium
    fontSize: 16.0,
    height: 1.5,
  );
}
