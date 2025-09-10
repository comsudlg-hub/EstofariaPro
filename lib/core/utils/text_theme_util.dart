import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(
    BuildContext? context, String bodyFontString, String displayFontString) {
  final baseTextTheme = context != null
      ? Theme.of(context).textTheme
      : Typography.material2018().black;

  final bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  final displayTextTheme = GoogleFonts.getTextTheme(displayFontString, baseTextTheme);

  return displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
}
