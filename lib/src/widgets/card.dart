import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Size presets for Warcraft cards.
enum WarcraftCardSize { md, sm }

/// Warcraft-themed card with framed background.
class WarcraftCard extends StatelessWidget {
  const WarcraftCard({
    super.key,
    required this.child,
    this.size = WarcraftCardSize.md,
    this.maxWidth = 546,
    this.minHeight,
    this.sliceInsets = const EdgeInsets.all(48),
    this.contentPadding = const EdgeInsets.fromLTRB(62, 56, 62, 44),
  });

  final Widget child;
  final WarcraftCardSize size;
  final double maxWidth;

  /// Optional minimum height. Left `null` by default so the card sizes to
  /// its actual [child] content instead of reserving dead space.
  final double? minHeight;
  final EdgeInsets sliceInsets;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    // `heightFactor: 1` keeps this shrink-wrapped to its own content height
    // (Align otherwise expands to fill any bounded ambient height, e.g. a
    // full Scaffold body) while still left-aligning horizontally when a
    // wider parent gives more width than [maxWidth].
    return Align(
      alignment: Alignment.centerLeft,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, minHeight: minHeight ?? 0),
        child: SizedBox(
          width: double.infinity,
          child: DefaultTextStyle.merge(
            style: WarcraftTheme.baseTextStyle(context).copyWith(
              color: WarcraftColors.cardForeground,
              fontSize: size == WarcraftCardSize.sm
                  ? WarcraftTokens.typeMd
                  : WarcraftTokens.typeLg,
            ),
            child: WarcraftBorderBox(
              asset: WarcraftAssets.cardBg,
              sliceInsets: sliceInsets,
              padding: contentPadding,
              borderRadius: BorderRadius.circular(12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class WarcraftCardSection extends StatelessWidget {
  const WarcraftCardSection({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: child,
    );
  }
}

class WarcraftCardHeader extends StatelessWidget {
  const WarcraftCardHeader({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WarcraftCardSection(
      padding: const EdgeInsets.fromLTRB(8, 18, 8, 6),
      child: child,
    );
  }
}

class WarcraftCardContent extends StatelessWidget {
  const WarcraftCardContent({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WarcraftCardSection(child: child);
  }
}

class WarcraftCardFooter extends StatelessWidget {
  const WarcraftCardFooter({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WarcraftCardSection(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
      child: child,
    );
  }
}
