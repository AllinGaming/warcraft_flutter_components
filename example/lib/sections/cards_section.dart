import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases a plain [WarcraftCard] and a card composed from
/// [WarcraftCardHeader], [WarcraftCardContent], and [WarcraftCardFooter].
class CardsSection extends StatelessWidget {
  const CardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WarcraftCard(
          elevation: 10,
          semanticLabel: 'Warcraft card sizing example',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WarcraftCard content goes here.'),
              SizedBox(height: 8),
              Text(
                'This card sizes to its content by default (minHeight is '
                'null unless overridden), so short bodies no longer leave '
                'dead space below them.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const WarcraftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              WarcraftCardHeader(child: Text('Quest: The Lost Relic')),
              WarcraftCardContent(
                child: Text(
                  'Composed from WarcraftCardHeader, WarcraftCardContent, '
                  'and WarcraftCardFooter sections.',
                ),
              ),
              WarcraftCardFooter(child: Text('Reward: 200 gold')),
            ],
          ),
        ),
      ],
    );
  }
}
