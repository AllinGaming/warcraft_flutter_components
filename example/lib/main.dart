import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

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

/// Interactive design-system showcase for the package.
class WarcraftExampleApp extends StatefulWidget {
  const WarcraftExampleApp({super.key});

  @override
  State<WarcraftExampleApp> createState() => _WarcraftExampleAppState();
}

class _WarcraftExampleAppState extends State<WarcraftExampleApp> {
  WarcraftFaction _faction = WarcraftFaction.defaultFaction;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warcraft Components',
      debugShowCheckedModeBanner: false,
      theme: WarcraftTheme.themeData(faction: _faction),
      home: ComponentShowcase(
        faction: _faction,
        onFactionChanged: (faction) => setState(() => _faction = faction),
      ),
    );
  }
}

/// Responsive shell that presents every component as a cohesive system.
class ComponentShowcase extends StatelessWidget {
  const ComponentShowcase({
    super.key,
    required this.faction,
    required this.onFactionChanged,
  });

  /// Active showcase palette.
  final WarcraftFaction faction;

  /// Called when the visitor selects another palette.
  final ValueChanged<WarcraftFaction> onFactionChanged;

  static const _sections = <_ShowcaseItem>[
    _ShowcaseItem(
      'Buttons',
      'Actions, sizes, states, and keyboard behavior',
      Icons.ads_click_rounded,
      ButtonsSection(),
    ),
    _ShowcaseItem(
      'Badges',
      'Status, faction, size, and silhouette variants',
      Icons.workspace_premium_rounded,
      BadgesSection(),
    ),
    _ShowcaseItem(
      'Card',
      'Ornamental surfaces and composable sections',
      Icons.auto_awesome_mosaic_rounded,
      CardsSection(),
    ),
    _ShowcaseItem(
      'Inputs',
      'Focused, disabled, and multiline form controls',
      Icons.edit_note_rounded,
      InputsSection(),
    ),
    _ShowcaseItem(
      'Label',
      'Field labels and required-state treatment',
      Icons.label_outline_rounded,
      LabelsSection(),
    ),
    _ShowcaseItem(
      'Checkbox & Radio',
      'Faction controls with accessible states',
      Icons.check_circle_outline_rounded,
      CheckboxRadioSection(),
    ),
    _ShowcaseItem(
      'Tabs',
      'Horizontal, vertical, and faction navigation',
      Icons.tab_rounded,
      TabsSection(),
    ),
    _ShowcaseItem(
      'Accordion',
      'Animated disclosure with semantic state',
      Icons.view_agenda_outlined,
      AccordionSection(),
    ),
    _ShowcaseItem(
      'Pagination',
      'Responsive page-window navigation',
      Icons.more_horiz_rounded,
      PaginationSection(),
    ),
    _ShowcaseItem(
      'Tooltip',
      'Rarity-aware contextual information',
      Icons.info_outline_rounded,
      TooltipSection(),
    ),
    _ShowcaseItem(
      'Spinner & Skeleton',
      'Loading feedback across factions',
      Icons.hourglass_top_rounded,
      SpinnerSkeletonSection(),
    ),
    _ShowcaseItem(
      'Avatar',
      'Character identity, sizes, and fallbacks',
      Icons.account_circle_outlined,
      AvatarSection(),
    ),
    _ShowcaseItem(
      'Dropdown Menu',
      'Actions, selection, and nested navigation',
      Icons.menu_open_rounded,
      DropdownMenuSection(),
    ),
    _ShowcaseItem(
      'Toast',
      'Stacked notifications by intent and position',
      Icons.notifications_active_outlined,
      ToastSection(),
    ),
    _ShowcaseItem(
      'Cursor',
      'Pointer affordances for desktop and web',
      Icons.mouse_outlined,
      CursorSection(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Warcraft UI Components'),
        backgroundColor: theme.background.withAlpha(235),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: theme.border.withAlpha(130)),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: WarcraftTokens.spacingLg),
            child: Center(
              child: WarcraftBadge(
                size: WarcraftBadgeSize.sm,
                variant: WarcraftBadgeVariant.outline,
                child: Text('v1.0'),
              ),
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.7, -0.8),
            radius: 1.4,
            colors: [theme.primary.withAlpha(38), theme.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 64),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Hero(faction: faction, onFactionChanged: onFactionChanged),
                    const SizedBox(height: WarcraftTokens.spacing3xl),
                    for (var index = 0; index < _sections.length; index++) ...[
                      _SectionCard(item: _sections[index]),
                      const SizedBox(height: WarcraftTokens.spacing2xl),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.faction, required this.onFactionChanged});

  final WarcraftFaction faction;
  final ValueChanged<WarcraftFaction> onFactionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(WarcraftTokens.spacing2xl),
      decoration: BoxDecoration(
        color: theme.surface.withAlpha(230),
        borderRadius: BorderRadius.circular(WarcraftTokens.radiusLg),
        border: Border.all(color: theme.border.withAlpha(180)),
        boxShadow: [
          BoxShadow(
            color: theme.shadow,
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FORGE YOUR INTERFACE',
                style: WarcraftTheme.baseTextStyle(context).copyWith(
                  color: theme.primary,
                  fontSize: WarcraftTokens.typeSm,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.4,
                ),
              ),
              const SizedBox(height: WarcraftTokens.spacingSm),
              Text(
                'A production-ready fantasy UI kit for Flutter.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: theme.foreground,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: WarcraftTokens.spacingMd),
              Text(
                'Explore accessible components, responsive patterns, and '
                'live faction-aware theming built for mobile, desktop, and web.',
                style: WarcraftTheme.baseTextStyle(context).copyWith(
                  color: theme.mutedForeground,
                  fontSize: WarcraftTokens.typeLg,
                ),
              ),
            ],
          );
          final selector = _FactionSelector(
            faction: faction,
            onChanged: onFactionChanged,
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, const SizedBox(height: 24), selector],
            );
          }
          return Row(
            children: [
              Expanded(flex: 3, child: copy),
              const SizedBox(width: 40),
              Expanded(flex: 2, child: selector),
            ],
          );
        },
      ),
    );
  }
}

class _FactionSelector extends StatelessWidget {
  const _FactionSelector({required this.faction, required this.onChanged});

  final WarcraftFaction faction;
  final ValueChanged<WarcraftFaction> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LIVE PALETTE',
          style: WarcraftTheme.baseTextStyle(context).copyWith(
            color: theme.mutedForeground,
            fontSize: WarcraftTokens.typeXs,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: WarcraftTokens.spacingSm),
        Wrap(
          spacing: WarcraftTokens.spacingSm,
          runSpacing: WarcraftTokens.spacingSm,
          children: [
            for (final option in WarcraftFaction.values)
              ChoiceChip(
                label: Text(option.label),
                selected: faction == option,
                onSelected: (_) => onChanged(option),
                selectedColor: theme.primary,
                backgroundColor: theme.surfaceElevated,
                side: BorderSide(
                  color: faction == option ? theme.focusRing : theme.border,
                ),
                labelStyle: TextStyle(
                  color: faction == option
                      ? theme.primaryForeground
                      : theme.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.item});
  final _ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(WarcraftTokens.spacingXl),
      decoration: BoxDecoration(
        color: theme.surface.withAlpha(210),
        borderRadius: BorderRadius.circular(WarcraftTokens.radiusLg),
        border: Border.all(color: theme.border.withAlpha(115)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primary.withAlpha(24),
                  borderRadius: BorderRadius.circular(WarcraftTokens.radiusSm),
                  border: Border.all(color: theme.primary.withAlpha(100)),
                ),
                child: Icon(item.icon, color: theme.primary, size: 21),
              ),
              const SizedBox(width: WarcraftTokens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: theme.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.description,
                      style: WarcraftTheme.baseTextStyle(context).copyWith(
                        color: theme.mutedForeground,
                        fontSize: WarcraftTokens.typeMd,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: WarcraftTokens.spacingXl),
          item.child,
        ],
      ),
    );
  }
}

class _ShowcaseItem {
  const _ShowcaseItem(this.title, this.description, this.icon, this.child);

  final String title;
  final String description;
  final IconData icon;
  final Widget child;
}
