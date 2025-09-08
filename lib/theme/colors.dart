/// Cores da paleta Couro Moderno - EstofariaPro
/// Definições estratégicas de UI/UX
library estofariapro_colors;

import 'package:flutter/material.dart';

class EstofariaColors {
  // Cores Principais da Marca (Splash, Onboarding, Dashboards)
  static const Color primaryBrown = Color(0xFFB85C38);
  static const Color primaryCream = Color(0xFFD9BCA3);

  // Cores de Suporte e Neutras (Login, Cadastro, Fundos)
  static const Color neutralLight = Color(0xFFF6F3F0);
  static const Color neutralDark = Color(0xFF2B2B2B);
  static const Color cardDark = Color(0xFF6C4F3D);

  // Cores de Status e Feedback (Consistentes em todos os dashboards)
  static const Color statusWaiting = Color(0xFFFFA500); // Laranja - Aguardando
  static const Color statusPricing = Color(0xFF0000FF); // Azul - Precificando
  static const Color statusApproved = Color(0xFF008000); // Verde - Aprovado
  static const Color statusRejected = Color(0xFFFF0000); // Vermelho - Rejeitado

  // Gradientes Animados (Onboarding e Dashboards)
  static Gradient get primaryGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryBrown, primaryCream],
      stops: [0.0, 1.0],
    );
  }

  // Gradiente para modos escuros
  static Gradient get darkGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [neutralDark, cardDark],
      stops: [0.0, 1.0],
    );
  }
}
