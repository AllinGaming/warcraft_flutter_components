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
        .map((child) => Padding(
              padding: EdgeInsets.only(
                right: direction == Axis.horizontal ? spacing : 0,
                bottom: direction == Axis.vertical ? spacing : 0,
              ),
              child: child,
            ))
        .toList();

    return direction == Axis.horizontal
        ? Wrap(children: content)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: content);
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
    final socket = Semantics(
      inMutuallyExclusiveGroup: true,
      checked: _selected,
      enabled: _interactive,
      child: GestureDetector(
        onTap: _interactive ? () => onChanged!(value) : null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: WarcraftTokens.minTapTarget,
            minHeight: WarcraftTokens.minTapTarget,
          ),
          child: Center(
            child: Opacity(
              opacity: enabled ? 1 : WarcraftTokens.disabledOpacity,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    center: Alignment(-0.2, -0.2),
                    colors: [Color(0xFF3B2F20), Color(0xFF1A140D)],
                    stops: [0, 1],
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 3,
                        offset: Offset(0, 1)),
                  ],
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selected
                        ? const Color(0xFFD97706)
                        : Colors.transparent,
                    boxShadow: _selected
                        ? const [
                            BoxShadow(color: Color(0xFFFFE39C), blurRadius: 6),
                          ]
                        : const [],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (label == null) {
      return socket;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        socket,
        const SizedBox(width: WarcraftTokens.spacingSm),
        DefaultTextStyle.merge(
          style: WarcraftTheme.baseTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
            fontSize: WarcraftTokens.typeLg,
            color: WarcraftColors.cardForeground,
          ),
          child: label!,
        ),
      ],
    );
  }
}
