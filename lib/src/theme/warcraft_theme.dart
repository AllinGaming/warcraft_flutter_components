import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Core color palette for Warcraft UI.
class WarcraftColors {
  const WarcraftColors._();

  static const Color amber100 = Color(0xFFFFF3C1);
  static const Color amber200 = Color(0xFFFCD34D);
  static const Color amber400 = Color(0xFFF59E0B);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber900 = Color(0xFF78350F);
  static const Color cardForeground = Color(0xFFF3E7C4);

  static const Color textMuted = Color(0xFFB9A780);

  static const Color orcRed = Color(0xFFB91C1C);
  static const Color elfGreen = Color(0xFF15803D);
  static const Color humanBlue = Color(0xFF2563EB);
  static const Color undeadPurple = Color(0xFF6B21A8);
}

/// Typography helpers for Warcraft UI.
class WarcraftTheme {
  const WarcraftTheme._();

  static TextStyle baseTextStyle(BuildContext context) {
    return GoogleFonts.cinzel(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      letterSpacing: 0.5,
      height: 1.5,
    );
  }

  static TextTheme textTheme(BuildContext context) {
    final base = Theme.of(context).textTheme;
    return GoogleFonts.cinzelTextTheme(base).copyWith(
      bodyMedium: GoogleFonts.cinzel(textStyle: base.bodyMedium),
      bodySmall: GoogleFonts.cinzel(textStyle: base.bodySmall),
      titleMedium: GoogleFonts.cinzel(textStyle: base.titleMedium),
      titleSmall: GoogleFonts.cinzel(textStyle: base.titleSmall),
      labelLarge: GoogleFonts.cinzel(textStyle: base.labelLarge),
    );
  }
}
