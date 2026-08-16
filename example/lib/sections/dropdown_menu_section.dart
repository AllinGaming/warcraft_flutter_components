import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftDropdownMenu] with a label, action, checkbox, radio,
/// separator, and submenu entry, plus an enabled and a disabled trigger.
class DropdownMenuSection extends StatefulWidget {
  const DropdownMenuSection({super.key});

  @override
  State<DropdownMenuSection> createState() => _DropdownMenuSectionState();
}

class _DropdownMenuSectionState extends State<DropdownMenuSection> {
  bool _autoEquip = true;
  String _difficulty = 'normal';

  List<WarcraftMenuEntry> get _items => [
        const WarcraftMenuLabel('Actions'),
        WarcraftMenuAction(
          label: 'Inspect',
          leading: const Icon(Icons.search_rounded),
          trailing: const Text('I'),
          onSelected: () {},
        ),
        WarcraftMenuAction(
          label: 'Equip',
          leading: const Icon(Icons.shield_outlined),
          trailing: const Text('E'),
          onSelected: () {},
        ),
        const WarcraftMenuAction(label: 'Requires level 40', enabled: false),
        const WarcraftMenuSeparator(),
        WarcraftMenuCheckbox(
          label: 'Auto-equip',
          value: _autoEquip,
          onChanged: (next) => setState(() => _autoEquip = next),
        ),
        WarcraftMenuRadio<String>(
          label: 'Normal',
          value: 'normal',
          groupValue: _difficulty,
          onChanged: (next) => setState(() => _difficulty = next),
        ),
        WarcraftMenuRadio<String>(
          label: 'Heroic',
          value: 'heroic',
          groupValue: _difficulty,
          onChanged: (next) => setState(() => _difficulty = next),
        ),
        const WarcraftMenuSeparator(),
        WarcraftMenuSubmenu(
          label: 'More',
          children: [
            WarcraftMenuAction(label: 'Sell', onSelected: () {}),
            WarcraftMenuAction(label: 'Discard', onSelected: () {}),
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        WarcraftDropdownMenu(
          items: _items,
          child: const WarcraftButton(
            onPressed: null,
            child: Text('Open Menu'),
          ),
        ),
        WarcraftDropdownMenu(
          enabled: false,
          items: _items,
          child: const WarcraftButton(
            onPressed: null,
            child: Text('Disabled Menu'),
          ),
        ),
      ],
    );
  }
}
