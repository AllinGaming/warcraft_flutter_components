import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Visual variants for labels.
enum WarcraftLabelVariant {
  /// Standard, fully opaque label styling with a subtle glow.
  defaultVariant,

  /// Dimmed styling for de-emphasized labels.
  muted,
}

/// Warcraft-styled label with optional required marker.
class WarcraftLabel extends StatelessWidget {
  /// Creates a [WarcraftLabel].
  const WarcraftLabel({
    super.key,
    required this.text,
    this.variant = WarcraftLabelVariant.defaultVariant,
    this.isRequired = false,
    this.enabled = true,
  });

  /// The label text to display.
  final String text;

  /// Which visual style to render the label with.
  final WarcraftLabelVariant variant;

  /// Whether to show a required-field marker after the text.
  final bool isRequired;

  /// Whether the label is rendered at full opacity (`true`) or dimmed to
  /// indicate a disabled state (`false`).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final style = WarcraftTheme.baseTextStyle(context).copyWith(
      fontSize: WarcraftTokens.typeMd,
      fontWeight: FontWeight.w600,
      color: variant == WarcraftLabelVariant.muted
          ? WarcraftColors.amber200.withAlpha(153)
          : WarcraftColors.amber200,
      shadows: variant == WarcraftLabelVariant.defaultVariant
          ? [
              Shadow(
                  color: WarcraftColors.amber400.withAlpha(64), blurRadius: 6)
            ]
          : const [],
    );

    return Opacity(
      opacity: enabled ? 1 : WarcraftTokens.disabledOpacity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: style),
          if (isRequired) ...[
            const SizedBox(width: WarcraftTokens.spacingXs),
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
