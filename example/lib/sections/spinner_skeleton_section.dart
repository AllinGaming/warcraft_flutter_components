import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftSpinner] and [WarcraftSkeleton] in both shapes across
/// several factions.
class SpinnerSkeletonSection extends StatelessWidget {
  const SpinnerSkeletonSection({super.key});

  static const _factions = [
    WarcraftFaction.defaultFaction,
    WarcraftFaction.orc,
    WarcraftFaction.elf,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WarcraftSpinner(),
        const SizedBox(height: 16),
        const Text(
          'Rounded skeletons',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final faction in _factions)
              WarcraftSkeleton(width: 160, height: 20, faction: faction),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Circular skeletons',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final faction in _factions)
              WarcraftSkeleton(
                width: 48,
                height: 48,
                faction: faction,
                shape: WarcraftSkeletonShape.circular,
              ),
          ],
        ),
      ],
    );
  }
}
