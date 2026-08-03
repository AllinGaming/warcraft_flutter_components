import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftCheckbox] across every faction plus a disabled
/// instance, and [WarcraftRadioGroup]/[WarcraftRadio] in both vertical and
/// horizontal layouts.
class CheckboxRadioSection extends StatefulWidget {
  const CheckboxRadioSection({super.key});

  @override
  State<CheckboxRadioSection> createState() => _CheckboxRadioSectionState();
}

class _CheckboxRadioSectionState extends State<CheckboxRadioSection> {
  final Map<WarcraftFaction, bool> _checked = {
    for (final faction in WarcraftFaction.values) faction: false,
  };
  String _verticalFaction = 'orc';
  String _horizontalFaction = 'orc';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            for (final faction in WarcraftFaction.values)
              WarcraftCheckbox(
                value: _checked[faction]!,
                faction: faction,
                label: Text(faction.name),
                onChanged: (next) => setState(() => _checked[faction] = next),
              ),
            const WarcraftCheckbox(
              value: true,
              enabled: false,
              label: Text('Disabled'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Vertical radio group', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        WarcraftRadioGroup<String>(
          children: [
            WarcraftRadio<String>(
              value: 'orc',
              groupValue: _verticalFaction,
              label: const Text('Orc'),
              onChanged: (v) => setState(() => _verticalFaction = v),
            ),
            WarcraftRadio<String>(
              value: 'elf',
              groupValue: _verticalFaction,
              label: const Text('Elf'),
              onChanged: (v) => setState(() => _verticalFaction = v),
            ),
            WarcraftRadio<String>(
              value: 'human',
              groupValue: _verticalFaction,
              label: const Text('Human'),
              onChanged: (v) => setState(() => _verticalFaction = v),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Horizontal radio group', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        WarcraftRadioGroup<String>(
          direction: Axis.horizontal,
          children: [
            WarcraftRadio<String>(
              value: 'orc',
              groupValue: _horizontalFaction,
              label: const Text('Orc'),
              onChanged: (v) => setState(() => _horizontalFaction = v),
            ),
            WarcraftRadio<String>(
              value: 'elf',
              groupValue: _horizontalFaction,
              label: const Text('Elf'),
              onChanged: (v) => setState(() => _horizontalFaction = v),
            ),
          ],
        ),
      ],
    );
  }
}
