import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';

/// Callback signature for Warcraft radio changes.
typedef WarcraftRadioChanged<T> = void Function(T value);

/// Simple radio group layout for Warcraft radios.
class WarcraftRadioGroup<T> extends StatelessWidget {
  const WarcraftRadioGroup({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.spacing = 12,
  });

  final List<Widget> children;
  final Axis direction;
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
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: content);
  }
}

/// Warcraft-styled radio control.
class WarcraftRadio<T> extends StatelessWidget {
  const WarcraftRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  final T value;
  final T groupValue;
  final WarcraftRadioChanged<T>? onChanged;
  final Widget? label;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final socket = GestureDetector(
      onTap: onChanged != null ? () => onChanged!(value) : null,
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
            BoxShadow(color: Colors.black54, blurRadius: 3, offset: Offset(0, 1)),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _selected ? const Color(0xFFD97706) : Colors.transparent,
            boxShadow: _selected
                ? const [
                    BoxShadow(color: Color(0xFFFFE39C), blurRadius: 6),
                  ]
                : const [],
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
        const SizedBox(width: 8),
        DefaultTextStyle.merge(
          style: WarcraftTheme.baseTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: WarcraftColors.cardForeground,
          ),
          child: label!,
        ),
      ],
    );
  }
}
