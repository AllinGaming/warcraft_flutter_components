import 'package:flutter/material.dart';

/// Core color palette for Warcraft UI.
class WarcraftColors {
  const WarcraftColors._();

  /// Lightest amber tone, used for subtle highlights and light backgrounds.
  static const Color amber100 = Color(0xFFFFF3C1);

  /// Light amber tone, used for secondary highlights.
  static const Color amber200 = Color(0xFFFCD34D);

  /// Mid-tone amber, used for accents such as glow/shadow effects.
  static const Color amber400 = Color(0xFFF59E0B);

  /// Mid-tone amber (same value as [amber400]), used for primary accents.
  static const Color amber500 = Color(0xFFF59E0B);

  /// Darkest amber tone, used for deep backgrounds and borders.
  static const Color amber900 = Color(0xFF78350F);

  /// Default text color used inside card content.
  static const Color cardForeground = Color(0xFFF3E7C4);

  /// Muted text color used for lower-emphasis/secondary text.
  static const Color textMuted = Color(0xFFB9A780);

  /// Horde/Orc-associated red accent color.
  static const Color orcRed = Color(0xFFB91C1C);

  /// Elf-associated green accent color.
  static const Color elfGreen = Color(0xFF15803D);

  /// Human/Alliance-associated blue accent color.
  static const Color humanBlue = Color(0xFF2563EB);

  /// Undead-associated purple accent color.
  static const Color undeadPurple = Color(0xFF6B21A8);
}

/// Typography helpers for Warcraft UI.
///
/// The "Cinzel" font is bundled directly as a package asset (see
/// `pubspec.yaml`'s `fonts:` section) rather than fetched at runtime via
/// `google_fonts` — a runtime network fetch would silently fall back to the
/// platform's default font (no crash, no warning) whenever a consumer app
/// has no network entitlement (e.g. a sandboxed macOS/iOS release build) or
/// no connectivity, which defeats the entire point of a themed widget kit.
/// Bundling makes the font available immediately, on every platform, with
/// no network dependency at all.
class WarcraftTheme {
  const WarcraftTheme._();

  // Fonts declared inside a *package's own* pubspec.yaml are registered
  // under a `packages/<package_name>/<family>` namespaced key (to avoid
  // clashing with a consuming app's own fonts) — referencing the bare
  // family name here would silently fail to match and fall back to the
  // platform default font, with no error or warning of any kind.
  /// The namespaced font family key for the bundled "Cinzel" package font.
  static const String fontFamily =
      'packages/warcraft_flutter_components/Cinzel';

  /// Returns the base text style for Warcraft UI, derived from the ambient
  /// theme's `bodyMedium` style with [fontFamily] and Warcraft-specific
  /// spacing/line-height applied.
  static TextStyle baseTextStyle(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    return base.copyWith(
      fontFamily: fontFamily,
      letterSpacing: 0.5,
      height: 1.5,
    );
  }

  /// Returns a copy of the ambient [TextTheme] with [fontFamily] applied to
  /// all text styles.
  static TextTheme textTheme(BuildContext context) {
    return Theme.of(context).textTheme.apply(fontFamily: fontFamily);
  }
}
