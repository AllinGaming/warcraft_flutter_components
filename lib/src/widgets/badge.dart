import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import 'border_box.dart';

/// Visual variants for Warcraft badges.
enum WarcraftBadgeVariant { defaultVariant, secondary, destructive, outline }
/// Size presets for badges.
enum WarcraftBadgeSize { sm, md, lg }
/// Faction tinting for badges.
enum WarcraftBadgeFaction { none, alliance, horde }
/// Shape variants for badges.
enum WarcraftBadgeShape { defaultShape, shield, banner }

/// Warcraft-themed badge with frame and optional faction tint.
class WarcraftBadge extends StatelessWidget {
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

  final Widget child;
  final WarcraftBadgeVariant variant;
  final WarcraftBadgeSize size;
  final WarcraftBadgeFaction faction;
  final WarcraftBadgeShape shape;
  final double maxWidth;
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

    final tinted = _factionBackground(decorated);

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
        return 10;
      case WarcraftBadgeSize.md:
        return 12;
      case WarcraftBadgeSize.lg:
        return 14;
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
        return [Shadow(color: WarcraftColors.amber400.withAlpha(102), blurRadius: 8)];
      default:
        return const [];
    }
  }

  BorderRadius _borderRadius() {
    switch (shape) {
      case WarcraftBadgeShape.shield:
        return const BorderRadius.vertical(top: Radius.circular(4), bottom: Radius.circular(12));
      case WarcraftBadgeShape.banner:
        return BorderRadius.zero;
      case WarcraftBadgeShape.defaultShape:
        return BorderRadius.circular(4);
    }
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
