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

  /// Extra-small gap, in logical pixels.
  static const double spacingXs = 4;

  /// Small gap, in logical pixels.
  static const double spacingSm = 8;

  /// Medium gap, in logical pixels.
  static const double spacingMd = 12;

  /// Large gap, in logical pixels.
  static const double spacingLg = 16;

  /// Extra-large gap, in logical pixels.
  static const double spacingXl = 24;

  /// Double-extra-large gap, used between major page sections.
  static const double spacing2xl = 32;

  /// Triple-extra-large gap, used for spacious showcase layouts.
  static const double spacing3xl = 48;

  /// Extra-small font size, in logical pixels.
  static const double typeXs = 10;

  /// Small font size, in logical pixels.
  static const double typeSm = 11;

  /// Medium font size, in logical pixels.
  static const double typeMd = 12;

  /// Base (body) font size, in logical pixels.
  static const double typeBase = 13;

  /// Large font size, in logical pixels.
  static const double typeLg = 14;

  /// Small heading font size, in logical pixels.
  static const double typeXl = 18;

  /// Medium heading font size, in logical pixels.
  static const double type2xl = 24;

  /// Display font size, in logical pixels.
  static const double type3xl = 32;

  /// Opacity applied to disabled interactive widgets.
  static const double disabledOpacity = 0.5;

  /// Minimum interactive dimension recommended by both the Material and
  /// iOS HIG accessibility guidelines (48x48 logical pixels).
  static const double minTapTarget = 48.0;

  /// Compact corner radius for controls and badges.
  static const double radiusSm = 6;

  /// Default corner radius for menus and panels.
  static const double radiusMd = 10;

  /// Large corner radius for elevated surfaces.
  static const double radiusLg = 16;

  /// Fast interaction animation duration.
  static const Duration motionFast = Duration(milliseconds: 120);

  /// Standard component animation duration.
  static const Duration motionNormal = Duration(milliseconds: 220);

  /// Slower entrance/exit animation duration.
  static const Duration motionSlow = Duration(milliseconds: 320);
}
