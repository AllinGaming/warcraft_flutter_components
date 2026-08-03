import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Tooltip rarity variants.
enum WarcraftTooltipVariant { defaultVariant, uncommon, rare, epic, legendary }

/// Warcraft-styled tooltip with rarity colors.
class WarcraftTooltip extends StatelessWidget {
  const WarcraftTooltip({
    super.key,
    required this.child,
    required this.title,
    this.body,
    this.variant = WarcraftTooltipVariant.defaultVariant,
    this.waitDuration = Duration.zero,
  });

  final Widget child;
  final String title;
  final String? body;
  final WarcraftTooltipVariant variant;
  final Duration waitDuration;

  @override
  Widget build(BuildContext context) {
    final titleStyle = WarcraftTheme.baseTextStyle(context).copyWith(
      color: _titleColor(),
      fontWeight: FontWeight.bold,
      fontSize: WarcraftTokens.typeBase,
    );

    final bodyStyle = WarcraftTheme.baseTextStyle(context).copyWith(
      color: WarcraftColors.amber100.withAlpha(204),
      fontSize: WarcraftTokens.typeSm,
    );

    // Own the accessible string explicitly instead of relying on Tooltip's
    // internal richMessage.toPlainText() fallback, which naively
    // concatenates title+body with no punctuation.
    final semanticMessage = body == null ? title : '$title. $body';

    return Semantics(
      tooltip: semanticMessage,
      child: Tooltip(
        waitDuration: waitDuration,
        decoration: _decoration(),
        excludeFromSemantics: true,
        richMessage: TextSpan(
          style: WarcraftTheme.baseTextStyle(context).copyWith(
            color: WarcraftColors.amber100,
          ),
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

  Color _titleColor() {
    switch (variant) {
      case WarcraftTooltipVariant.uncommon:
        return const Color(0xFF4ADE80);
      case WarcraftTooltipVariant.rare:
        return const Color(0xFF60A5FA);
      case WarcraftTooltipVariant.epic:
        return const Color(0xFFC084FC);
      case WarcraftTooltipVariant.legendary:
        return const Color(0xFFF59E0B);
      case WarcraftTooltipVariant.defaultVariant:
        return WarcraftColors.amber200;
    }
  }

  Decoration _decoration() {
    final border = _borderColor();
    return BoxDecoration(
      color: const Color(0xFF111827),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: border),
      boxShadow: const [
        BoxShadow(color: Colors.black87, blurRadius: 20, offset: Offset(0, 6)),
      ],
    );
  }

  Color _borderColor() {
    switch (variant) {
      case WarcraftTooltipVariant.uncommon:
        return const Color(0xFF22C55E);
      case WarcraftTooltipVariant.rare:
        return const Color(0xFF3B82F6);
      case WarcraftTooltipVariant.epic:
        return const Color(0xFF7C3AED);
      case WarcraftTooltipVariant.legendary:
        return const Color(0xFFF97316);
      case WarcraftTooltipVariant.defaultVariant:
        return const Color(0xFF6B4A16);
    }
  }
}
