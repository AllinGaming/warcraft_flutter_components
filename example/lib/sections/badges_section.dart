import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftBadge] variant x size combinations, faction tinting,
/// and shapes.
class BadgesSection extends StatelessWidget {
  const BadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final variant in WarcraftBadgeVariant.values)
              for (final size in WarcraftBadgeSize.values)
                WarcraftBadge(
                  variant: variant,
                  size: size,
                  child: Text('${variant.name} ${size.name}'),
                ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Faction tinting', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            WarcraftBadge(
              faction: WarcraftBadgeFaction.alliance,
              child: Text('Alliance'),
            ),
            WarcraftBadge(
              faction: WarcraftBadgeFaction.horde,
              child: Text('Horde'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Shapes', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            WarcraftBadge(
              shape: WarcraftBadgeShape.defaultShape,
              child: Text('Default'),
            ),
            WarcraftBadge(
              shape: WarcraftBadgeShape.shield,
              child: Text('Shield'),
            ),
            WarcraftBadge(
              shape: WarcraftBadgeShape.banner,
              child: Text('Banner'),
            ),
          ],
        ),
      ],
    );
  }
}
