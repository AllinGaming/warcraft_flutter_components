import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Visual variants for Warcraft badges.
enum WarcraftBadgeVariant {
  /// Default gold/amber styling with the ornate carved-frame asset.
  defaultVariant,

  /// Muted styling for lower-emphasis badges.
  secondary,

  /// Red-tinted styling for warning or destructive states.
  destructive,

  /// Minimal outlined styling without the ornate frame asset.
  outline,
}

/// Size presets for badges.
enum WarcraftBadgeSize {
  /// Small badge size.
  sm,

  /// Medium (default) badge size.
  md,

  /// Large badge size.
  lg,
}

/// Faction tinting for badges.
enum WarcraftBadgeFaction {
  /// No faction tint applied.
  none,

  /// Alliance blue background tint.
  alliance,

  /// Horde red background tint.
  horde,
}

/// Shape variants for badges.
enum WarcraftBadgeShape {
  /// Default rounded-rectangle shape.
  defaultShape,

  /// Shield-like shape with an asymmetric rounded bottom.
  shield,

  /// Banner shape with notched bottom corners.
  banner,
}

/// Warcraft-themed badge with frame and optional faction tint.
class WarcraftBadge extends StatelessWidget {
  /// Creates a [WarcraftBadge].
  const WarcraftBadge({
    super.key,
    required this.child,
    this.variant = WarcraftBadgeVariant.defaultVariant,
    this.size = WarcraftBadgeSize.md,
    this.faction = WarcraftBadgeFaction.none,
    this.shape = WarcraftBadgeShape.defaultShape,
    this.maxWidth = 160,
    this.sliceInsets = const EdgeInsets.all(2),
  });

  /// The content displayed inside the badge.
  final Widget child;

  /// The visual style variant of the badge. See [WarcraftBadgeVariant].
  final WarcraftBadgeVariant variant;

  /// The size preset of the badge. See [WarcraftBadgeSize].
  final WarcraftBadgeSize size;

  /// Optional faction tint applied to the badge background. See
  /// [WarcraftBadgeFaction].
  final WarcraftBadgeFaction faction;

  /// The shape of the badge. See [WarcraftBadgeShape].
  final WarcraftBadgeShape shape;

  /// The maximum width the badge is allowed to grow to.
  final double maxWidth;

  /// The nine-slice insets used when rendering the badge's frame asset.
  final EdgeInsets sliceInsets;

  @override
  Widget build(BuildContext context) {
    final padding = _paddingForSize(size);
    final textStyle = WarcraftTheme.baseTextStyle(context).copyWith(
      fontSize: _fontSizeForSize(size),
      fontWeight: FontWeight.w600,
      color: _textColor(),
      shadows: _textShadows(),
    );

    final content = DefaultTextStyle.merge(
      style: textStyle,
      child: child,
    );

    final Widget decorated;
    if (variant == WarcraftBadgeVariant.outline) {
      decorated = Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(102),
          borderRadius: _borderRadius(),
          border: Border.all(color: const Color(0xFF6B4A16)),
        ),
        child: content,
      );
    } else {
      decorated = WarcraftBorderBox(
        asset: _borderAsset(),
        sliceInsets: sliceInsets,
        padding: EdgeInsets.zero,
        borderRadius: _borderRadius(),
        child: Padding(
          padding: padding,
          child: Center(child: content),
        ),
      );
    }

    final tinted = _factionBackground(_variantBackground(decorated));

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: ClipPath(
        clipper: _clipper(),
        child: tinted,
      ),
    );
  }

  String _borderAsset() {
    switch (variant) {
      case WarcraftBadgeVariant.secondary:
        return WarcraftAssets.buttonBg;
      case WarcraftBadgeVariant.destructive:
        return WarcraftAssets.buttonBgWithFrame;
      case WarcraftBadgeVariant.defaultVariant:
        return WarcraftAssets.buttonBgWithFrame;
      case WarcraftBadgeVariant.outline:
        return WarcraftAssets.buttonBg;
    }
  }

  EdgeInsets _paddingForSize(WarcraftBadgeSize size) {
    switch (size) {
      case WarcraftBadgeSize.sm:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 4);
      case WarcraftBadgeSize.md:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
      case WarcraftBadgeSize.lg:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
    }
  }

  double _fontSizeForSize(WarcraftBadgeSize size) {
    switch (size) {
      case WarcraftBadgeSize.sm:
        return WarcraftTokens.typeXs;
      case WarcraftBadgeSize.md:
        return WarcraftTokens.typeMd;
      case WarcraftBadgeSize.lg:
        return WarcraftTokens.typeLg;
    }
  }

  Color _textColor() {
    switch (variant) {
      case WarcraftBadgeVariant.destructive:
        return const Color(0xFFFCA5A5);
      case WarcraftBadgeVariant.secondary:
        return const Color(0xFFE2E8F0);
      case WarcraftBadgeVariant.outline:
        return const Color(0xFFFDE68A);
      case WarcraftBadgeVariant.defaultVariant:
        return const Color(0xFFFEF3C7);
    }
  }

  List<Shadow> _textShadows() {
    switch (variant) {
      case WarcraftBadgeVariant.destructive:
        return [Shadow(color: Colors.redAccent.withAlpha(102), blurRadius: 8)];
      case WarcraftBadgeVariant.defaultVariant:
        return [
          Shadow(color: WarcraftColors.amber400.withAlpha(102), blurRadius: 8)
        ];
      default:
        return const [];
    }
  }

  BorderRadius _borderRadius() {
    switch (shape) {
      case WarcraftBadgeShape.shield:
        return const BorderRadius.vertical(
            top: Radius.circular(4), bottom: Radius.circular(12));
      case WarcraftBadgeShape.banner:
        return BorderRadius.zero;
      case WarcraftBadgeShape.defaultShape:
        return BorderRadius.circular(4);
    }
  }

  /// `destructive` shares its frame asset with `defaultVariant` (there's no
  /// separate carved-frame art for it), so it needs its own background wash
  /// to read as visually distinct rather than differing only by text color.
  /// Reuses the same wash technique — and the same horde red — as
  /// [_factionBackground].
  Widget _variantBackground(Widget child) {
    if (variant != WarcraftBadgeVariant.destructive) {
      return child;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF450A0A).withAlpha(140),
        border: Border.all(color: const Color(0xFF7F1D1D).withAlpha(153)),
      ),
      child: child,
    );
  }

  Widget _factionBackground(Widget child) {
    switch (faction) {
      case WarcraftBadgeFaction.alliance:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withAlpha(153),
            border: Border.all(color: const Color(0xFF1E3A8A).withAlpha(128)),
          ),
          child: child,
        );
      case WarcraftBadgeFaction.horde:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF450A0A).withAlpha(153),
            border: Border.all(color: const Color(0xFF7F1D1D).withAlpha(128)),
          ),
          child: child,
        );
      case WarcraftBadgeFaction.none:
        return child;
    }
  }

  CustomClipper<Path> _clipper() {
    switch (shape) {
      case WarcraftBadgeShape.banner:
        return _BannerClipper();
      default:
        return const _NoClipper();
    }
  }
}

class _NoClipper extends CustomClipper<Path> {
  const _NoClipper();

  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final notch = size.height * 0.3;
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - notch, size.height);
    path.lineTo(notch, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
