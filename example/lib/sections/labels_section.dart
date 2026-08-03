import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftLabel] variants, the required marker, and disabled
/// state. Note the constructor param is `isRequired` (renamed from
/// `required` in a recent breaking change).
class LabelsSection extends StatelessWidget {
  const LabelsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 24,
      runSpacing: 12,
      children: [
        WarcraftLabel(text: 'Default label'),
        WarcraftLabel(text: 'Muted label', variant: WarcraftLabelVariant.muted),
        WarcraftLabel(text: 'Hero Name', isRequired: true),
        WarcraftLabel(text: 'Disabled label', enabled: false),
      ],
    );
  }
}
