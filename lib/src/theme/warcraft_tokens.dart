/// Shared layout/typography constants for Warcraft UI widgets.
///
/// These are deliberately limited to values that represent *layout
/// decisions* (gaps, type scale, disabled opacity, minimum tap target).
/// Pixel values that are bound to a specific piece of frame art (e.g. a
/// 9-slice border's carved-frame width) stay as local literals in their
/// widget file, since they encode the artwork's geometry rather than a
/// spacing choice.
class WarcraftTokens {
  const WarcraftTokens._();

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;

  static const double typeXs = 10;
  static const double typeSm = 11;
  static const double typeMd = 12;
  static const double typeBase = 13;
  static const double typeLg = 14;

  /// Opacity applied to disabled interactive widgets.
  static const double disabledOpacity = 0.5;

  /// Minimum interactive dimension recommended by both the Material and
  /// iOS HIG accessibility guidelines (48x48 logical pixels).
  static const double minTapTarget = 48.0;
}
