import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cria a hierarquia de tipografia baseada no Material Design 3
/// usando a fonte definida pelo time (Google Fonts).
TextTheme createTextTheme(Brightness brightness) {
  final base = brightness == Brightness.light
      ? Typography.blackMountainView
      : Typography.whiteMountainView;

  return GoogleFonts.robotoTextTheme(base).copyWith(
    displayLarge: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 57,
    ),
    headlineMedium: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    labelLarge: GoogleFonts.roboto(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 12,
    ),
  );
}
