import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Visual variants for labels.
enum WarcraftLabelVariant { defaultVariant, muted }

/// Warcraft-styled label with optional required marker.
class WarcraftLabel extends StatelessWidget {
  const WarcraftLabel({
    super.key,
    required this.text,
    this.variant = WarcraftLabelVariant.defaultVariant,
    this.isRequired = false,
    this.enabled = true,
  });

  final String text;
  final WarcraftLabelVariant variant;
  final bool isRequired;
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
          ? [Shadow(color: WarcraftColors.amber400.withAlpha(64), blurRadius: 6)]
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
