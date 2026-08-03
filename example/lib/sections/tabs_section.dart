import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftTabs] across every faction plus a vertical
/// orientation example.
class TabsSection extends StatelessWidget {
  const TabsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final faction in WarcraftFaction.values) ...[
          WarcraftTabs(
            labels: const ['Overview', 'Stats', 'Lore'],
            contents: const [
              Text('Overview content'),
              Text('Stats content'),
              Text('Lore content'),
            ],
            faction: faction,
          ),
          const SizedBox(height: 12),
        ],
        const Text('Vertical orientation', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        WarcraftTabs(
          orientation: Axis.vertical,
          labels: const ['Overview', 'Stats', 'Lore'],
          contents: const [
            Text('Overview content'),
            Text('Stats content'),
            Text('Lore content'),
          ],
        ),
      ],
    );
  }
}
