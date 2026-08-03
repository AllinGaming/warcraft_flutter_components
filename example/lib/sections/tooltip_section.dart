import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftTooltip] across all five rarity variants.
class TooltipSection extends StatelessWidget {
  const TooltipSection({super.key});

  static const _variants = [
    WarcraftTooltipVariant.defaultVariant,
    WarcraftTooltipVariant.uncommon,
    WarcraftTooltipVariant.rare,
    WarcraftTooltipVariant.epic,
    WarcraftTooltipVariant.legendary,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            for (final variant in _variants)
              WarcraftTooltip(
                title: '${variant.name} Item',
                body: 'A ${variant.name} rarity artifact.',
                variant: variant,
                child: WarcraftButton(
                  onPressed: () {},
                  child: Text(variant.name),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Long-press (touch) or hover (desktop/web) a button to see its '
          'tooltip.',
          style: TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}
