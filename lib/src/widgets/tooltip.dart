import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Tooltip rarity variants.
enum WarcraftTooltipVariant {
  /// Standard, non-rarity tooltip styling.
  defaultVariant,

  /// Uncommon (green) rarity styling.
  uncommon,

  /// Rare (blue) rarity styling.
  rare,

  /// Epic (purple) rarity styling.
  epic,

  /// Legendary (orange) rarity styling.
  legendary,
}

/// Warcraft-styled tooltip with rarity colors.
class WarcraftTooltip extends StatelessWidget {
  /// Creates a [WarcraftTooltip].
  const WarcraftTooltip({
    super.key,
    required this.child,
    required this.title,
    this.body,
    this.variant = WarcraftTooltipVariant.defaultVariant,
    this.waitDuration = Duration.zero,
    this.showDuration = const Duration(milliseconds: 1500),
    this.exitDuration = const Duration(milliseconds: 100),
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.margin = const EdgeInsets.all(8),
    this.verticalOffset = 24,
    this.preferBelow = true,
    this.constraints = const BoxConstraints(maxWidth: 320),
    this.enableTapToDismiss = true,
  }) : assert(verticalOffset >= 0);

  /// Widget that triggers the tooltip when hovered, long-pressed, or
  /// focused.
  final Widget child;

  /// Bold heading text shown at the top of the tooltip.
  final String title;

  /// Optional secondary text shown below [title].
  final String? body;

  /// Rarity styling applied to the tooltip's border and title color.
  final WarcraftTooltipVariant variant;

  /// Delay before the tooltip becomes visible after a hover/long-press.
  final Duration waitDuration;

  /// How long a tooltip triggered by touch remains visible.
  final Duration showDuration;

  /// Delay before a hovered tooltip disappears after the pointer exits.
  final Duration exitDuration;

  /// Space around the tooltip's title and body.
  final EdgeInsetsGeometry padding;

  /// Minimum distance between the tooltip and the screen edge.
  final EdgeInsetsGeometry margin;

  /// Distance between the tooltip and its trigger.
  final double verticalOffset;

  /// Whether the tooltip prefers placement below its trigger.
  final bool preferBelow;

  /// Optional size constraints for long tooltip content.
  final BoxConstraints? constraints;

  /// Whether tapping outside or on the trigger dismisses a shown tooltip.
  final bool enableTapToDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    final titleStyle = WarcraftTheme.baseTextStyle(context).copyWith(
      color: _titleColor(theme),
      fontWeight: FontWeight.bold,
      fontSize: WarcraftTokens.typeBase,
    );

    final bodyStyle = WarcraftTheme.baseTextStyle(
      context,
    ).copyWith(color: theme.mutedForeground, fontSize: WarcraftTokens.typeSm);

    // Own the accessible string explicitly instead of relying on Tooltip's
    // internal richMessage.toPlainText() fallback, which naively
    // concatenates title+body with no punctuation.
    final semanticMessage = body == null ? title : '$title. $body';

    return Semantics(
      tooltip: semanticMessage,
      child: Tooltip(
        waitDuration: waitDuration,
        showDuration: showDuration,
        exitDuration: exitDuration,
        padding: padding,
        margin: margin,
        verticalOffset: verticalOffset,
        preferBelow: preferBelow,
        constraints: constraints,
        enableTapToDismiss: enableTapToDismiss,
        decoration: _decoration(theme),
        excludeFromSemantics: true,
        richMessage: TextSpan(
          style: WarcraftTheme.baseTextStyle(
            context,
          ).copyWith(color: theme.foreground),
          children: [
            TextSpan(text: title, style: titleStyle),
            if (body != null) ...[
              const TextSpan(text: '\n'),
              TextSpan(text: body, style: bodyStyle),
            ],
          ],
        ),
        child: child,
      ),
    );
  }

  Color _titleColor(WarcraftThemeData theme) {
    switch (variant) {
      case WarcraftTooltipVariant.uncommon:
        return theme.success;
      case WarcraftTooltipVariant.rare:
        return theme.info;
      case WarcraftTooltipVariant.epic:
        return const Color(0xFFC084FC);
      case WarcraftTooltipVariant.legendary:
        return theme.warning;
      case WarcraftTooltipVariant.defaultVariant:
        return theme.primary;
    }
  }

  Decoration _decoration(WarcraftThemeData theme) {
    final border = _borderColor(theme);
    return BoxDecoration(
      color: theme.surfaceElevated,
      borderRadius: BorderRadius.circular(theme.radius),
      border: Border.all(color: border),
      boxShadow: [
        BoxShadow(
          color: theme.shadow,
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Color _borderColor(WarcraftThemeData theme) {
    switch (variant) {
      case WarcraftTooltipVariant.uncommon:
        return theme.success;
      case WarcraftTooltipVariant.rare:
        return theme.info;
      case WarcraftTooltipVariant.epic:
        return const Color(0xFF7C3AED);
      case WarcraftTooltipVariant.legendary:
        return theme.warning;
      case WarcraftTooltipVariant.defaultVariant:
        return theme.border;
    }
  }
}
