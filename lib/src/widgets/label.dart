import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';

/// Visual variants for labels.
enum WarcraftLabelVariant { defaultVariant, muted }

/// Warcraft-styled label with optional required marker.
class WarcraftLabel extends StatelessWidget {
  const WarcraftLabel({
    super.key,
    required this.text,
    this.variant = WarcraftLabelVariant.defaultVariant,
    this.required = false,
    this.enabled = true,
  });

  final String text;
  final WarcraftLabelVariant variant;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final style = WarcraftTheme.baseTextStyle(context).copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: variant == WarcraftLabelVariant.muted
          ? WarcraftColors.amber200.withAlpha(153)
          : WarcraftColors.amber200,
      shadows: variant == WarcraftLabelVariant.defaultVariant
          ? [Shadow(color: WarcraftColors.amber400.withAlpha(64), blurRadius: 6)]
          : const [],
    );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: style),
          if (required) ...[
            const SizedBox(width: 4),
            Text(
              '✦',
              style: style.copyWith(color: Colors.redAccent),
            ),
          ],
        ],
      ),
    );
  }
}
