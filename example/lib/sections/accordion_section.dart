import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftAccordion] with all three [WarcraftAccordionIcon]
/// variants.
class AccordionSection extends StatelessWidget {
  const AccordionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return WarcraftAccordion(
      items: [
        WarcraftAccordionItem(
          title: 'Quest Details',
          content: const Text('Bring me 5 wolf pelts.'),
          icon: WarcraftAccordionIcon.sword,
          isExpanded: true,
        ),
        WarcraftAccordionItem(
          title: 'Rewards',
          content: const Text('150 gold and a rare trinket.'),
          icon: WarcraftAccordionIcon.shield,
        ),
        WarcraftAccordionItem(
          title: 'Lore',
          content: const Text('Ancient runestones mark the path forward.'),
          icon: WarcraftAccordionIcon.runeStone,
        ),
      ],
    );
  }
}
