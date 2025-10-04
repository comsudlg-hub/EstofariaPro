import 'package:flutter/material.dart';

/// ColorScheme simplificado e compatível com versões estáveis
/// anteriores ao Flutter 3.16.
/// Baseado no JSON exportado pelo Material Theme Builder.

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF8F4C33),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFDBCF),
  onPrimaryContainer: Color(0xFF72361E),
  secondary: Color(0xFF8E4C32),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFDBCE),
  onSecondaryContainer: Color(0xFF71361D),
  tertiary: Color(0xFF8B4F25),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDBC7),
  onTertiaryContainer: Color(0xFF6E380F),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF93000A),
  background: Color(0xFFFFF8F6),
  onBackground: Color(0xFF231A16),
  surface: Color(0xFFF9FAEF),
  onSurface: Color(0xFF1A1D16),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFB59A),
  onPrimary: Color(0xFF4D1607),
  primaryContainer: Color(0xFF6E2C1B),
  onPrimaryContainer: Color(0xFFFFDBCF),
  secondary: Color(0xFFFFB599),
  onSecondary: Color(0xFF4D1607),
  secondaryContainer: Color(0xFF71361D),
  onSecondaryContainer: Color(0xFFFFDBCE),
  tertiary: Color(0xFFFFB688),
  onTertiary: Color(0xFF311300),
  tertiaryContainer: Color(0xFF6E380F),
  onTertiaryContainer: Color(0xFFFFDBC7),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1A1D16),
  onBackground: Color(0xFFE2E3D9),
  surface: Color(0xFF1A1D16),
  onSurface: Color(0xFFE2E3D9),
);
