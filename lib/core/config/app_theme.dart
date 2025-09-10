import 'package:flutter/material.dart';

/// Classe gerada pelo MD3 Theme Builder
class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  // ---------------- LIGHT ----------------
  static ColorScheme lightScheme() { ... } // já existente
  ThemeData light() => theme(lightScheme());

  // ---------------- DARK ----------------
  static ColorScheme darkScheme() { ... } // já existente
  ThemeData dark() => theme(darkScheme());

  // ---------------- HIGH / MEDIUM CONTRAST ----------------
  static ColorScheme lightMediumContrastScheme() { ... }
  ThemeData lightMediumContrast() => theme(lightMediumContrastScheme());

  static ColorScheme lightHighContrastScheme() { ... }
  ThemeData lightHighContrast() => theme(lightHighContrastScheme());

  static ColorScheme darkMediumContrastScheme() { ... }
  ThemeData darkMediumContrast() => theme(darkMediumContrastScheme());

  static ColorScheme darkHighContrastScheme() { ... }
  ThemeData darkHighContrast() => theme(darkHighContrastScheme());

  // ---------------- BASE THEME ----------------
  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );
}

/// Classe simples para facilitar o acesso no projeto
class AppTheme {
  static final MaterialTheme _materialTheme =
      MaterialTheme(Typography.material2021().black);

  static ThemeData light = _materialTheme.light();
  static ThemeData dark = _materialTheme.dark();

  // Se quiser contrastes opcionais:
  static ThemeData lightHighContrast = _materialTheme.lightHighContrast();
  static ThemeData darkHighContrast = _materialTheme.darkHighContrast();
}
