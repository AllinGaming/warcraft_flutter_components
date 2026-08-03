import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftCursor] for a couple of factions. This is a no-op on
/// touch devices by design (hover-only), so it only does something visually
/// on desktop/web with a real mouse pointer.
class CursorSection extends StatelessWidget {
  const CursorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            WarcraftCursor(
              faction: WarcraftFaction.orc,
              child: Container(
                width: 220,
                height: 100,
                alignment: Alignment.center,
                color: const Color(0xFF2D0B0B),
                child: const Text(
                  'Hover here (desktop/web)\nfor the orc cursor',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            WarcraftCursor(
              faction: WarcraftFaction.elf,
              child: Container(
                width: 220,
                height: 100,
                alignment: Alignment.center,
                color: const Color(0xFF0A2C28),
                child: const Text(
                  'Hover here (desktop/web)\nfor the elf cursor',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'No-op on touch devices: only a real mouse pointer triggers the '
          'custom cursor.',
          style: TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}
