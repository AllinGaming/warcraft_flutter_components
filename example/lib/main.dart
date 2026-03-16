import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  runApp(const WarcraftExampleApp());
}

class WarcraftExampleApp extends StatelessWidget {
  const WarcraftExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warcraft Components',
      theme: ThemeData.dark(),
      home: const ComponentShowcase(),
    );
  }
}

class ComponentShowcase extends StatefulWidget {
  const ComponentShowcase({super.key});

  @override
  State<ComponentShowcase> createState() => _ComponentShowcaseState();
}

class _ComponentShowcaseState extends State<ComponentShowcase> {
  bool checkboxValue = false;
  int currentPage = 1;
  int tabIndex = 0;
  String selectedFaction = 'orc';
  late final List<WarcraftAccordionItem> accordionItems;

  @override
  void initState() {
    super.initState();
    accordionItems = [
      WarcraftAccordionItem(
        title: 'Quest Details',
        content: const Text('Bring me 5 wolf pelts.'),
        icon: WarcraftAccordionIcon.sword,
      ),
      WarcraftAccordionItem(
        title: 'Rewards',
        content: const Text('150 gold and a rare trinket.'),
        icon: WarcraftAccordionIcon.shield,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Warcraft UI Components')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buttons'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                WarcraftButton(
                  child: const Text('Default'),
                  onPressed: () {},
                ),
                WarcraftButton(
                  variant: WarcraftButtonVariant.frame,
                  child: const Text('Frame'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Badges'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: const [
                WarcraftBadge(child: Text('Default')),
                WarcraftBadge(
                  variant: WarcraftBadgeVariant.secondary,
                  child: Text('Secondary'),
                ),
                WarcraftBadge(
                  variant: WarcraftBadgeVariant.destructive,
                  child: Text('Destructive'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Card'),
            const SizedBox(height: 8),
            const WarcraftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WarcraftCard content goes here.'),
                  SizedBox(height: 8),
                  Text(
                      'This card demonstrates longer body copy so you can see how the frame behaves with multiple lines of text.'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Inputs'),
            const SizedBox(height: 8),
            const WarcraftInput(
              hintText: 'Enter your name...',
              capWidth: 8,
              textPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              maxWidth: 520,
            ),
            const SizedBox(height: 12),
            const WarcraftTextarea(
              hintText: 'Your quest details',
              capWidth: 26,
              textPadding: EdgeInsets.fromLTRB(26, 20, 26, 20),
              maxWidth: 520,
            ),
            const SizedBox(height: 24),
            const Text('Label'),
            const SizedBox(height: 8),
            const WarcraftLabel(text: 'Hero Name', required: true),
            const SizedBox(height: 24),
            const Text('Checkbox & Radio'),
            const SizedBox(height: 8),
            WarcraftCheckbox(
              value: checkboxValue,
              onChanged: (next) => setState(() => checkboxValue = next),
              label: const Text('Accept the quest'),
              faction: WarcraftFaction.human,
            ),
            const SizedBox(height: 12),
            WarcraftRadioGroup<String>(
              direction: Axis.horizontal,
              children: [
                WarcraftRadio<String>(
                  value: 'orc',
                  groupValue: selectedFaction,
                  onChanged: (value) => setState(() => selectedFaction = value),
                  label: const Text('Orc'),
                ),
                WarcraftRadio<String>(
                  value: 'elf',
                  groupValue: selectedFaction,
                  onChanged: (value) => setState(() => selectedFaction = value),
                  label: const Text('Elf'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Tabs'),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WarcraftTabs(
                  labels: const ['Overview', 'Stats', 'Lore'],
                  contents: const [
                    Text('Overview content'),
                    Text('Stats content'),
                    Text('Lore content'),
                  ],
                  faction: WarcraftFaction.defaultFaction,
                  onChanged: (index) => setState(() => tabIndex = index),
                  initialIndex: tabIndex,
                ),
                const SizedBox(height: 12),
                WarcraftTabs(
                  labels: const ['Orc', 'Elf', 'Human'],
                  contents: const [
                    Text('Orc content'),
                    Text('Elf content'),
                    Text('Human content'),
                  ],
                  faction: WarcraftFaction.orc,
                ),
                const SizedBox(height: 12),
                WarcraftTabs(
                  labels: const ['Elf', 'Human', 'Undead'],
                  contents: const [
                    Text('Elf content'),
                    Text('Human content'),
                    Text('Undead content'),
                  ],
                  faction: WarcraftFaction.elf,
                ),
                const SizedBox(height: 12),
                WarcraftTabs(
                  labels: const ['Human', 'Undead', 'Orc'],
                  contents: const [
                    Text('Human content'),
                    Text('Undead content'),
                    Text('Orc content'),
                  ],
                  faction: WarcraftFaction.human,
                ),
                const SizedBox(height: 12),
                WarcraftTabs(
                  labels: const ['Undead', 'Orc', 'Elf'],
                  contents: const [
                    Text('Undead content'),
                    Text('Orc content'),
                    Text('Elf content'),
                  ],
                  faction: WarcraftFaction.undead,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Accordion'),
            const SizedBox(height: 8),
            WarcraftAccordion(
              items: accordionItems,
            ),
            const SizedBox(height: 24),
            const Text('Pagination'),
            const SizedBox(height: 8),
            WarcraftPagination(
              currentPage: currentPage,
              pageCount: 20,
              onPageChanged: (page) => setState(() => currentPage = page),
            ),
            const SizedBox(height: 24),
            const Text('Tooltip'),
            const SizedBox(height: 8),
            WarcraftTooltip(
              title: 'Legendary Sword',
              body: 'A blade forged in ancient fire.',
              variant: WarcraftTooltipVariant.legendary,
              child: const Icon(Icons.info_outline),
            ),
            const SizedBox(height: 24),
            const Text('Spinner & Skeleton'),
            const SizedBox(height: 8),
            const WarcraftSpinner(),
            const SizedBox(height: 12),
            const WarcraftSkeleton(width: 200, height: 20),
            const SizedBox(height: 24),
            const Text('Avatar'),
            const SizedBox(height: 8),
            const WarcraftAvatar(
              faction: WarcraftFaction.human,
              size: WarcraftAvatarSize.sm,
              fallback: Text('U'),
            ),
            const SizedBox(height: 24),
            const Text('Dropdown Menu'),
            const SizedBox(height: 8),
            WarcraftDropdownMenu(
              items: [
                const WarcraftMenuLabel('Actions'),
                WarcraftMenuAction(label: 'Inspect', onSelected: () {}),
                WarcraftMenuAction(label: 'Equip', onSelected: () {}),
                const WarcraftMenuSeparator(),
                WarcraftMenuCheckbox(
                  label: 'Auto-equip',
                  value: true,
                  onChanged: (_) {},
                ),
                WarcraftMenuSubmenu(
                  label: 'More',
                  children: [
                    WarcraftMenuAction(label: 'Sell', onSelected: () {}),
                    WarcraftMenuAction(label: 'Discard', onSelected: () {}),
                  ],
                ),
              ],
              child: const WarcraftButton(
                onPressed: null,
                child: Text('Open Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
