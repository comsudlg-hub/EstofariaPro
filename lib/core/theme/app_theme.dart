import 'package:flutter/material.dart';
import 'color_schemes.dart';
import '../utils/text_theme_util.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: createTextTheme(null, 'Roboto', 'Roboto'),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    textTheme: createTextTheme(null, 'Roboto', 'Roboto'),
  );
}
