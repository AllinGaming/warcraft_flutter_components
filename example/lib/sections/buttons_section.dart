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
              size: WarcraftButtonSize.lg,
              maxWidth: 280,
              semanticLabel: 'Begin adventure',
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded),
                  SizedBox(width: 8),
                  Text('Primary Quest'),
                ],
              ),
            ),
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
            const WarcraftButton(
              isLoading: true,
              loadingLabel: 'Forging',
              onPressed: _noop,
              child: Text('Craft'),
            ),
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

void _noop() {}
