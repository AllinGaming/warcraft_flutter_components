import 'package:flutter/material.dart';

import '../foundation/warcraft_faction.dart';
import 'warcraft_tokens.dart';

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

/// Theme values shared by all Warcraft components.
///
/// Add an instance to [ThemeData.extensions] or use [WarcraftTheme.themeData]
/// to theme the entire component library. [classic] preserves the package's
/// original gold-on-charcoal identity while improving contrast and focus
/// visibility.
@immutable
class WarcraftThemeData extends ThemeExtension<WarcraftThemeData> {
  /// Creates a complete Warcraft component theme.
  const WarcraftThemeData({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.foreground,
    required this.mutedForeground,
    required this.primary,
    required this.primaryForeground,
    required this.focusRing,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.shadow,
    this.disabledOpacity = WarcraftTokens.disabledOpacity,
    this.radius = WarcraftTokens.radiusMd,
    this.motionDuration = WarcraftTokens.motionNormal,
  });

  /// The default neutral Warcraft palette.
  static const WarcraftThemeData classic = WarcraftThemeData(
    background: Color(0xFF0C0906),
    surface: Color(0xFF17100A),
    surfaceElevated: Color(0xFF24190E),
    border: Color(0xFF76521D),
    foreground: Color(0xFFF8EDCF),
    mutedForeground: Color(0xFFC4B38B),
    primary: Color(0xFFF0B429),
    primaryForeground: Color(0xFF1A1004),
    focusRing: Color(0xFFFFD66B),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    danger: Color(0xFFF87171),
    info: Color(0xFF60A5FA),
    shadow: Color(0xCC000000),
  );

  /// Creates the default theme with accents tailored to [faction].
  factory WarcraftThemeData.forFaction(WarcraftFaction faction) {
    switch (faction) {
      case WarcraftFaction.orc:
        return classic.copyWith(
          primary: const Color(0xFFEF4444),
          primaryForeground: Colors.white,
          focusRing: const Color(0xFFFCA5A5),
          border: const Color(0xFF8F2D25),
        );
      case WarcraftFaction.elf:
        return classic.copyWith(
          primary: const Color(0xFF5EEAD4),
          primaryForeground: const Color(0xFF052E2B),
          focusRing: const Color(0xFF99F6E4),
          border: const Color(0xFF287A70),
        );
      case WarcraftFaction.human:
        return classic.copyWith(
          primary: const Color(0xFF60A5FA),
          primaryForeground: const Color(0xFF071B34),
          focusRing: const Color(0xFFBFDBFE),
          border: const Color(0xFF315F9E),
        );
      case WarcraftFaction.undead:
        return classic.copyWith(
          primary: const Color(0xFFC084FC),
          primaryForeground: const Color(0xFF24102F),
          focusRing: const Color(0xFFE9D5FF),
          border: const Color(0xFF70418C),
        );
      case WarcraftFaction.defaultFaction:
        return classic;
    }
  }

  /// App background color.
  final Color background;

  /// Base component surface color.
  final Color surface;

  /// Elevated menu, tooltip, and overlay surface color.
  final Color surfaceElevated;

  /// Default subtle border color.
  final Color border;

  /// High-emphasis text and icon color.
  final Color foreground;

  /// Secondary text and icon color.
  final Color mutedForeground;

  /// Main accent color.
  final Color primary;

  /// Content color placed on [primary].
  final Color primaryForeground;

  /// Keyboard focus indicator color.
  final Color focusRing;

  /// Positive state color.
  final Color success;

  /// Caution state color.
  final Color warning;

  /// Error and destructive state color.
  final Color danger;

  /// Informational state color.
  final Color info;

  /// Overlay and elevation shadow color.
  final Color shadow;

  /// Opacity for disabled components.
  final double disabledOpacity;

  /// Default component corner radius.
  final double radius;

  /// Standard interaction animation duration.
  final Duration motionDuration;

  @override
  WarcraftThemeData copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? border,
    Color? foreground,
    Color? mutedForeground,
    Color? primary,
    Color? primaryForeground,
    Color? focusRing,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? shadow,
    double? disabledOpacity,
    double? radius,
    Duration? motionDuration,
  }) {
    return WarcraftThemeData(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      foreground: foreground ?? this.foreground,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      focusRing: focusRing ?? this.focusRing,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      shadow: shadow ?? this.shadow,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      radius: radius ?? this.radius,
      motionDuration: motionDuration ?? this.motionDuration,
    );
  }

  @override
  WarcraftThemeData lerp(covariant WarcraftThemeData? other, double t) {
    if (other == null) return this;
    return WarcraftThemeData(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryForeground: Color.lerp(
        primaryForeground,
        other.primaryForeground,
        t,
      )!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      disabledOpacity: _lerpDouble(disabledOpacity, other.disabledOpacity, t),
      radius: _lerpDouble(radius, other.radius, t),
      motionDuration: Duration(
        microseconds: _lerpDouble(
          motionDuration.inMicroseconds.toDouble(),
          other.motionDuration.inMicroseconds.toDouble(),
          t,
        ).round(),
      ),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
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

  /// Returns the nearest [WarcraftThemeData], falling back to
  /// [WarcraftThemeData.classic] when the host app has not installed one.
  static WarcraftThemeData of(BuildContext context) {
    return Theme.of(context).extension<WarcraftThemeData>() ??
        WarcraftThemeData.classic;
  }

  /// Resolves a component animation duration while respecting the platform's
  /// reduced-motion preference.
  static Duration motionDurationOf(BuildContext context, {Duration? duration}) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return reduceMotion
        ? Duration.zero
        : (duration ?? of(context).motionDuration);
  }

  /// Builds a complete dark [ThemeData] suitable for Warcraft components and
  /// surrounding Material widgets.
  static ThemeData themeData({
    WarcraftFaction faction = WarcraftFaction.defaultFaction,
    WarcraftThemeData? data,
  }) {
    final resolved = data ?? WarcraftThemeData.forFaction(faction);
    final colorScheme = ColorScheme.dark(
      primary: resolved.primary,
      onPrimary: resolved.primaryForeground,
      secondary: resolved.primary,
      onSecondary: resolved.primaryForeground,
      error: resolved.danger,
      surface: resolved.surface,
      onSurface: resolved.foreground,
    );
    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: resolved.background,
      fontFamily: fontFamily,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: fontFamily,
        bodyColor: resolved.foreground,
        displayColor: resolved.foreground,
      ),
      dividerColor: resolved.border,
      focusColor: resolved.focusRing,
      extensions: <ThemeExtension<dynamic>>[resolved],
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 350),
        textStyle: base.textTheme.bodySmall?.copyWith(
          color: resolved.foreground,
        ),
      ),
    );
  }

  /// Returns the base text style for Warcraft UI, derived from the ambient
  /// theme's `bodyMedium` style with [fontFamily] and Warcraft-specific
  /// spacing/line-height applied.
  static TextStyle baseTextStyle(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    return base.copyWith(
      fontFamily: fontFamily,
      color: of(context).foreground,
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
