import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Size presets for Warcraft cards.
enum WarcraftCardSize {
  /// Medium (default) card size, using the larger base font size.
  md,

  /// Small card size, using a smaller base font size.
  sm,
}

/// Warcraft-themed card with framed background.
class WarcraftCard extends StatelessWidget {
  /// Creates a [WarcraftCard] wrapping [child] in a themed 9-slice frame.
  const WarcraftCard({
    super.key,
    required this.child,
    this.size = WarcraftCardSize.md,
    this.maxWidth = 546,
    this.minHeight,
    this.sliceInsets = const EdgeInsets.all(48),
    this.contentPadding = const EdgeInsets.fromLTRB(62, 56, 62, 44),
    this.elevation = 0,
    this.semanticLabel,
  });

  /// The content displayed inside the card frame.
  final Widget child;

  /// The size preset controlling the base font size. Defaults to
  /// [WarcraftCardSize.md].
  final WarcraftCardSize size;

  /// The maximum width of the card. Defaults to `546`.
  final double maxWidth;

  /// Optional minimum height. Left `null` by default so the card sizes to
  /// its actual [child] content instead of reserving dead space.
  final double? minHeight;

  /// The 9-slice insets applied to the card's background asset.
  final EdgeInsets sliceInsets;

  /// The padding applied around [child] inside the card frame.
  final EdgeInsets contentPadding;

  /// Visual elevation expressed as shadow blur strength.
  final double elevation;

  /// Optional accessible description for the card region.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    // `heightFactor: 1` keeps this shrink-wrapped to its own content height
    // (Align otherwise expands to fill any bounded ambient height, e.g. a
    // full Scaffold body) while still left-aligning horizontally when a
    // wider parent gives more width than [maxWidth].
    final card = Align(
      alignment: Alignment.centerLeft,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          minHeight: minHeight ?? 0,
        ),
        child: SizedBox(
          width: double.infinity,
          child: DefaultTextStyle.merge(
            style: WarcraftTheme.baseTextStyle(context).copyWith(
              color: theme.foreground,
              fontSize: size == WarcraftCardSize.sm
                  ? WarcraftTokens.typeMd
                  : WarcraftTokens.typeLg,
            ),
            child: WarcraftBorderBox(
              asset: WarcraftAssets.cardBg,
              sliceInsets: sliceInsets,
              padding: contentPadding,
              borderRadius: BorderRadius.circular(12),
              boxShadow: elevation > 0
                  ? [
                      BoxShadow(
                        color: theme.shadow,
                        blurRadius: elevation * 2,
                        offset: Offset(0, elevation * 0.5),
                      ),
                    ]
                  : null,
              child: child,
            ),
          ),
        ),
      ),
    );
    if (semanticLabel == null) return card;
    return Semantics(container: true, label: semanticLabel, child: card);
  }
}

/// A padded section within a [WarcraftCard], used to build
/// [WarcraftCardHeader], [WarcraftCardContent], and [WarcraftCardFooter].
class WarcraftCardSection extends StatelessWidget {
  /// Creates a [WarcraftCardSection] wrapping [child] with optional
  /// [padding].
  const WarcraftCardSection({super.key, required this.child, this.padding});

  /// The content displayed within the section.
  final Widget child;

  /// The padding applied around [child]. Defaults to
  /// `EdgeInsets.symmetric(horizontal: 8, vertical: 6)` when `null`.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: child,
    );
  }
}

/// A [WarcraftCardSection] preset for a card's header area.
class WarcraftCardHeader extends StatelessWidget {
  /// Creates a [WarcraftCardHeader] wrapping [child].
  const WarcraftCardHeader({super.key, required this.child});

  /// The content displayed in the header.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WarcraftCardSection(
      padding: const EdgeInsets.fromLTRB(8, 18, 8, 6),
      child: child,
    );
  }
}

/// A [WarcraftCardSection] preset for a card's main content area.
class WarcraftCardContent extends StatelessWidget {
  /// Creates a [WarcraftCardContent] wrapping [child].
  const WarcraftCardContent({super.key, required this.child});

  /// The content displayed in the card body.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WarcraftCardSection(child: child);
  }
}

/// A [WarcraftCardSection] preset for a card's footer area.
class WarcraftCardFooter extends StatelessWidget {
  /// Creates a [WarcraftCardFooter] wrapping [child].
  const WarcraftCardFooter({super.key, required this.child});

  /// The content displayed in the footer.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WarcraftCardSection(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
      child: child,
    );
  }
}
