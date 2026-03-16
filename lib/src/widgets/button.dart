import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import 'border_box.dart';

/// Visual variants for Warcraft buttons.
enum WarcraftButtonVariant { defaultVariant, frame }

/// Size presets for Warcraft buttons.
enum WarcraftButtonSize { md, sm }

/// Warcraft-themed button with frame variants and press animation.
class WarcraftButton extends StatefulWidget {
  const WarcraftButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = WarcraftButtonVariant.defaultVariant,
    this.size = WarcraftButtonSize.md,
    this.padding,
    this.maxWidth = 220,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final WarcraftButtonVariant variant;
  final WarcraftButtonSize size;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;

  bool get enabled => onPressed != null;

  @override
  State<WarcraftButton> createState() => _WarcraftButtonState();
}

class _WarcraftButtonState extends State<WarcraftButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final asset = _assetForVariant(widget.variant, widget.size);
    final contentPadding = widget.padding ?? _paddingForSize(widget.size);

    final child = DefaultTextStyle.merge(
      style: WarcraftTheme.baseTextStyle(context).copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: widget.size == WarcraftButtonSize.sm ? 12 : 14,
      ),
      child: IconTheme.merge(
        data: const IconThemeData(color: Colors.white, size: 18),
        child: widget.child,
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel:
            widget.enabled ? () => setState(() => _pressed = false) : null,
        onTapUp: widget.enabled
            ? (_) => setState(() => _pressed = false)
            : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 80),
          child: Opacity(
            opacity: widget.enabled ? 1 : 0.6,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _pressed ? Colors.black.withAlpha(51) : Colors.transparent,
                BlendMode.darken,
              ),
            child: WarcraftBorderBox(
              asset: asset,
              sliceInsets: const EdgeInsets.all(8),
              padding: contentPadding,
              child: child,
            ),
            ),
          ),
        ),
      ),
    );
  }

  String _assetForVariant(WarcraftButtonVariant variant, WarcraftButtonSize size) {
    switch (variant) {
      case WarcraftButtonVariant.frame:
        return size == WarcraftButtonSize.sm
            ? WarcraftAssets.buttonBgWithFrameSm
            : WarcraftAssets.buttonBgWithFrame;
      case WarcraftButtonVariant.defaultVariant:
        return size == WarcraftButtonSize.sm
            ? WarcraftAssets.buttonBgSm
            : WarcraftAssets.buttonBg;
    }
  }

  EdgeInsets _paddingForSize(WarcraftButtonSize size) {
    switch (size) {
      case WarcraftButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case WarcraftButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 18, vertical: 12);
    }
  }
}
