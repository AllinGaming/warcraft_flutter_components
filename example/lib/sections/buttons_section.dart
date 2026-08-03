import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftButton] variants, sizes, and disabled state.
class ButtonsSection extends StatelessWidget {
  const ButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            WarcraftButton(onPressed: () {}, child: const Text('Default')),
            WarcraftButton(
              variant: WarcraftButtonVariant.frame,
              onPressed: () {},
              child: const Text('Frame'),
            ),
            WarcraftButton(
              size: WarcraftButtonSize.sm,
              onPressed: () {},
              child: const Text('Small'),
            ),
            WarcraftButton(
              variant: WarcraftButtonVariant.frame,
              size: WarcraftButtonSize.sm,
              onPressed: () {},
              child: const Text('Small Frame'),
            ),
            const WarcraftButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Buttons activate via keyboard Enter/Space when focused, and show '
          'a pointer cursor on hover (desktop/web).',
          style: TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}
