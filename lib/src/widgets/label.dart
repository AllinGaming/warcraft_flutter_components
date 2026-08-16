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
    this.semanticLabel,
    this.requiredSemanticLabel = 'required',
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

  /// Optional accessible replacement for [text].
  final String? semanticLabel;

  /// Localizable word appended to the accessible label when [isRequired]
  /// is true. The decorative marker itself is excluded from semantics.
  final String requiredSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    final style = WarcraftTheme.baseTextStyle(context).copyWith(
      fontSize: WarcraftTokens.typeMd,
      fontWeight: FontWeight.w600,
      color: variant == WarcraftLabelVariant.muted
          ? theme.mutedForeground
          : theme.primary,
      shadows: variant == WarcraftLabelVariant.defaultVariant
          ? [Shadow(color: theme.primary.withAlpha(64), blurRadius: 6)]
          : const [],
    );

    final accessibleLabel =
        semanticLabel ?? (isRequired ? '$text, $requiredSemanticLabel' : null);
    final label = Opacity(
      opacity: enabled ? 1 : WarcraftTokens.disabledOpacity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: style),
          if (isRequired) ...[
            const SizedBox(width: WarcraftTokens.spacingXs),
            Text('✦', style: style.copyWith(color: theme.danger)),
          ],
        ],
      ),
    );

    return accessibleLabel == null
        ? label
        : Semantics(
            label: accessibleLabel,
            excludeSemantics: true,
            child: label,
          );
  }
}
