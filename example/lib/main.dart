import 'package:flutter/material.dart';

import 'sections/accordion_section.dart';
import 'sections/avatar_section.dart';
import 'sections/badges_section.dart';
import 'sections/buttons_section.dart';
import 'sections/cards_section.dart';
import 'sections/checkbox_radio_section.dart';
import 'sections/cursor_section.dart';
import 'sections/dropdown_menu_section.dart';
import 'sections/inputs_section.dart';
import 'sections/labels_section.dart';
import 'sections/pagination_section.dart';
import 'sections/spinner_skeleton_section.dart';
import 'sections/tabs_section.dart';
import 'sections/toast_section.dart';
import 'sections/tooltip_section.dart';

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

/// Thin shell that lists every widget's showcase section under a heading.
/// Each section's actual variant coverage lives in its own file under
/// `sections/`, mirroring the package's one-file-per-widget convention.
class ComponentShowcase extends StatelessWidget {
  const ComponentShowcase({super.key});

  static const _sections = <(String, Widget)>[
    ('Buttons', ButtonsSection()),
    ('Badges', BadgesSection()),
    ('Card', CardsSection()),
    ('Inputs', InputsSection()),
    ('Label', LabelsSection()),
    ('Checkbox & Radio', CheckboxRadioSection()),
    ('Tabs', TabsSection()),
    ('Accordion', AccordionSection()),
    ('Pagination', PaginationSection()),
    ('Tooltip', TooltipSection()),
    ('Spinner & Skeleton', SpinnerSkeletonSection()),
    ('Avatar', AvatarSection()),
    ('Dropdown Menu', DropdownMenuSection()),
    ('Toast', ToastSection()),
    ('Cursor', CursorSection()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Warcraft UI Components')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (title, section) in _sections) ...[
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              section,
              const SizedBox(height: 28),
            ],
          ],
        ),
      ),
    );
  }
}
