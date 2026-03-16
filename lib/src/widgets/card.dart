import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
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
    this.minHeight = 420,
    this.sliceInsets = const EdgeInsets.all(48),
    this.contentPadding = const EdgeInsets.fromLTRB(62, 56, 62, 44),
  });

  final Widget child;
  final WarcraftCardSize size;
  final double maxWidth;
  final double minHeight;
  final EdgeInsets sliceInsets;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, minHeight: minHeight),
        child: SizedBox(
          width: double.infinity,
          child: DefaultTextStyle.merge(
            style: WarcraftTheme.baseTextStyle(context).copyWith(
              color: WarcraftColors.cardForeground,
              fontSize: size == WarcraftCardSize.sm ? 12 : 14,
            ),
            child: WarcraftBorderBox(
              asset: WarcraftAssets.cardBg,
              sliceInsets: sliceInsets,
              padding: contentPadding,
              borderRadius: BorderRadius.circular(12),
              alignment: Alignment.topLeft,
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
