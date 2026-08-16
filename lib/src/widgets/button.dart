import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';
import 'spinner.dart';

/// Visual variants for Warcraft buttons.
enum WarcraftButtonVariant {
  /// Plain button background without a decorative frame.
  defaultVariant,

  /// Button background with a decorative frame overlay.
  frame,
}

/// Size presets for Warcraft buttons.
enum WarcraftButtonSize {
  /// Standard-sized button.
  md,

  /// Compact, smaller button.
  sm,

  /// Spacious button for primary calls to action.
  lg,
}

/// Warcraft-themed button with frame variants and press animation.
class WarcraftButton extends StatefulWidget {
  /// Creates a [WarcraftButton].
  const WarcraftButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = WarcraftButtonVariant.defaultVariant,
    this.size = WarcraftButtonSize.md,
    this.padding,
    this.maxWidth = 220,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.selected = false,
    this.isLoading = false,
    this.loadingLabel,
  });

  /// Content displayed inside the button.
  final Widget child;

  /// Called when the button is tapped or activated via keyboard (Enter or
  /// Space); the button is treated as disabled when this is null.
  final VoidCallback? onPressed;

  /// Visual style to render the button with.
  final WarcraftButtonVariant variant;

  /// Size preset controlling padding and text/icon scale.
  final WarcraftButtonSize size;

  /// Custom content padding; overrides the default padding for [size] when
  /// set.
  final EdgeInsetsGeometry? padding;

  /// Maximum width the button is constrained to.
  final double maxWidth;

  /// Optional focus node used for keyboard focus and activation.
  final FocusNode? focusNode;

  /// Whether this button should claim keyboard focus when first shown.
  final bool autofocus;

  /// Optional accessible label when [child] does not contain useful text.
  final String? semanticLabel;

  /// Whether assistive technology should announce this button as selected.
  final bool selected;

  /// Whether to replace [child] with a progress indicator and block input.
  final bool isLoading;

  /// Optional text shown beside the progress indicator and announced while
  /// [isLoading] is true.
  final String? loadingLabel;

  /// Whether the button responds to input; true when [onPressed] is set.
  bool get enabled => onPressed != null && !isLoading;

  @override
  State<WarcraftButton> createState() => _WarcraftButtonState();
}

class _WarcraftButtonState extends State<WarcraftButton> {
  bool _pressed = false;
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    final motionDuration = WarcraftTheme.motionDurationOf(
      context,
      duration: WarcraftTokens.motionFast,
    );
    final asset = _assetForVariant(widget.variant, widget.size);
    final contentPadding = widget.padding ?? _paddingForSize(widget.size);

    final normalChild = DefaultTextStyle.merge(
      style: WarcraftTheme.baseTextStyle(context).copyWith(
        color: theme.foreground,
        fontWeight: FontWeight.w600,
        fontSize: widget.size == WarcraftButtonSize.sm
            ? WarcraftTokens.typeMd
            : WarcraftTokens.typeLg,
      ),
      child: IconTheme.merge(
        data: IconThemeData(
          color: theme.foreground,
          size: widget.size == WarcraftButtonSize.lg ? 20 : 18,
        ),
        child: AnimatedSwitcher(
          duration: WarcraftTheme.motionDurationOf(context),
          child: widget.isLoading
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WarcraftSpinner(
                      size: 18,
                      strokeWidth: 2,
                      color: theme.foreground,
                      semanticLabel: null,
                    ),
                    if (widget.loadingLabel != null) ...[
                      const SizedBox(width: WarcraftTokens.spacingSm),
                      Text(widget.loadingLabel!),
                    ],
                  ],
                )
              : KeyedSubtree(
                  key: const ValueKey('content'),
                  child: widget.child,
                ),
        ),
      ),
    );

    final resolvedSemanticLabel = widget.isLoading
        ? (widget.loadingLabel ?? widget.semanticLabel ?? 'Loading')
        : widget.semanticLabel;

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: resolvedSemanticLabel,
      excludeSemantics: resolvedSemanticLabel != null,
      selected: widget.selected ? true : null,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          onFocusChange: (value) => setState(() => _focused = value),
          onKeyEvent: (node, event) {
            final isActivationKey =
                event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space;
            if (widget.enabled && isActivationKey && event is KeyDownEvent) {
              widget.onPressed?.call();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: widget.maxWidth),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: widget.enabled
                  ? (_) => setState(() => _pressed = true)
                  : null,
              onTapCancel: widget.enabled
                  ? () => setState(() => _pressed = false)
                  : null,
              onTapUp: widget.enabled
                  ? (_) => setState(() => _pressed = false)
                  : null,
              onTap: widget.enabled ? widget.onPressed : null,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: WarcraftTokens.minTapTarget,
                  minHeight: WarcraftTokens.minTapTarget,
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: motionDuration,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(theme.radius),
                      border: _focused
                          ? Border.all(color: theme.focusRing, width: 2)
                          : null,
                      boxShadow: _hovered
                          ? [
                              BoxShadow(
                                color: theme.primary.withAlpha(70),
                                blurRadius: 14,
                              ),
                            ]
                          : const [],
                    ),
                    child: AnimatedScale(
                      scale: _pressed ? 0.97 : (_hovered ? 1.015 : 1),
                      duration: motionDuration,
                      child: Opacity(
                        opacity: widget.enabled ? 1 : theme.disabledOpacity,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            _pressed
                                ? Colors.black.withAlpha(51)
                                : Colors.transparent,
                            BlendMode.darken,
                          ),
                          child: WarcraftBorderBox(
                            asset: asset,
                            sliceInsets: const EdgeInsets.all(8),
                            padding: contentPadding,
                            borderRadius: BorderRadius.circular(theme.radius),
                            child: normalChild,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _assetForVariant(
    WarcraftButtonVariant variant,
    WarcraftButtonSize size,
  ) {
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
      case WarcraftButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 15);
    }
  }
}
