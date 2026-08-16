import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Callback signature for Warcraft radio changes.
typedef WarcraftRadioChanged<T> = void Function(T value);

/// Simple radio group layout for Warcraft radios.
class WarcraftRadioGroup<T> extends StatelessWidget {
  /// Creates a group that lays out [children] (typically [WarcraftRadio]
  /// widgets) along [direction] with [spacing] between them.
  const WarcraftRadioGroup({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.spacing = WarcraftTokens.spacingMd,
  });

  /// The radios (or other widgets) to lay out.
  final List<Widget> children;

  /// The axis along which [children] are arranged.
  final Axis direction;

  /// The gap between consecutive [children], in logical pixels.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final content = children
        .map(
          (child) => Padding(
            padding: EdgeInsets.only(
              right: direction == Axis.horizontal ? spacing : 0,
              bottom: direction == Axis.vertical ? spacing : 0,
            ),
            child: child,
          ),
        )
        .toList();

    return direction == Axis.horizontal
        ? Wrap(children: content)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          );
  }
}

/// Warcraft-styled radio control.
class WarcraftRadio<T> extends StatelessWidget {
  /// Creates a Warcraft-styled radio button representing [value] within a
  /// group currently set to [groupValue].
  const WarcraftRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.enabled = true,
  });

  /// The value this radio button represents.
  final T value;

  /// The currently selected value for the enclosing group.
  ///
  /// This radio renders as selected when [value] equals [groupValue].
  final T groupValue;

  /// Called with [value] when the radio is tapped while [enabled] is true.
  ///
  /// If null, the radio is treated as non-interactive.
  final WarcraftRadioChanged<T>? onChanged;

  /// Optional label rendered to the right of the radio socket.
  final Widget? label;

  /// Whether the radio responds to input and renders at full opacity.
  final bool enabled;

  bool get _selected => value == groupValue;
  bool get _interactive => enabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    return MergeSemantics(
      child: Semantics(
        container: true,
        inMutuallyExclusiveGroup: true,
        checked: _selected,
        enabled: _interactive,
        onTap: _interactive ? () => onChanged!(value) : null,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _interactive ? () => onChanged!(value) : null,
            excludeFromSemantics: true,
            borderRadius: BorderRadius.circular(theme.radius),
            focusColor: theme.focusRing.withAlpha(45),
            hoverColor: theme.primary.withAlpha(24),
            mouseCursor: _interactive
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: WarcraftTokens.minTapTarget,
                minHeight: WarcraftTokens.minTapTarget,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: WarcraftTokens.minTapTarget,
                    height: WarcraftTokens.minTapTarget,
                    child: Center(
                      child: Opacity(
                        opacity: enabled ? 1 : theme.disabledOpacity,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(-0.2, -0.2),
                              colors: [theme.surfaceElevated, theme.surface],
                              stops: const [0, 1],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadow,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: AnimatedContainer(
                            duration: WarcraftTheme.motionDurationOf(context),
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selected
                                  ? theme.primary
                                  : Colors.transparent,
                              boxShadow: _selected
                                  ? [
                                      BoxShadow(
                                        color: theme.focusRing,
                                        blurRadius: 6,
                                      ),
                                    ]
                                  : const [],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (label != null) ...[
                    const SizedBox(width: WarcraftTokens.spacingSm),
                    Flexible(
                      child: DefaultTextStyle.merge(
                        style: WarcraftTheme.baseTextStyle(context).copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: WarcraftTokens.typeLg,
                          color: enabled
                              ? theme.foreground
                              : theme.mutedForeground,
                        ),
                        child: label!,
                      ),
                    ),
                    const SizedBox(width: WarcraftTokens.spacingSm),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
