/// Tema Global EstofariaPro - Couro Moderno
/// Define estilos para modo claro e escuro.
library estofariapro_theme;

import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class EstofariaTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: EstofariaColors.primaryBrown,
        secondary: EstofariaColors.primaryCream,
        background: EstofariaColors.neutralLight,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: Colors.black,
        onSurface: Colors.black,
      ),
      scaffoldBackgroundColor: EstofariaColors.neutralLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: EstofariaColors.primaryBrown,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: EstofariaTextStyles.displayLarge,
        titleLarge: EstofariaTextStyles.titleLarge,
        titleMedium: EstofariaTextStyles.titleMedium,
        bodyLarge: EstofariaTextStyles.bodyLarge,
        bodyMedium: EstofariaTextStyles.bodyMedium,
        bodySmall: EstofariaTextStyles.bodySmall,
        labelLarge: EstofariaTextStyles.button,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EstofariaColors.primaryBrown,
          foregroundColor: Colors.white,
          textStyle: EstofariaTextStyles.button,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: EstofariaColors.primaryBrown,
        secondary: EstofariaColors.primaryCream,
        background: EstofariaColors.neutralDark,
        surface: EstofariaColors.cardDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: EstofariaColors.neutralDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: EstofariaColors.neutralDark,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: EstofariaTextStyles.displayLarge.copyWith(color: Colors.white),
        titleLarge: EstofariaTextStyles.titleLarge.copyWith(color: Colors.white),
        titleMedium: EstofariaTextStyles.titleMedium.copyWith(color: Colors.white),
        bodyLarge: EstofariaTextStyles.bodyLarge.copyWith(color: Colors.white),
        bodyMedium: EstofariaTextStyles.bodyMedium.copyWith(color: Colors.white70),
        bodySmall: EstofariaTextStyles.bodySmall.copyWith(color: Colors.white60),
        labelLarge: EstofariaTextStyles.button.copyWith(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EstofariaColors.primaryBrown,
          foregroundColor: Colors.white,
          textStyle: EstofariaTextStyles.button,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EstofariaColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white60),
      ),
      cardTheme: CardTheme(
        color: EstofariaColors.cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
