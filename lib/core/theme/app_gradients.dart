import 'package:flutter/material.dart';

class AppGradients {
  static LinearGradient brownGradient(ColorScheme scheme) {
    return LinearGradient(
      colors: [
        scheme.primary.withOpacity(0.85),
        scheme.primaryContainer.withOpacity(0.65),
      ],
      begin: Alignment.centerLeft,   // agora começa na ESQUERDA
      end: Alignment.centerRight,    // vai para a DIREITA
    );
  }
}
