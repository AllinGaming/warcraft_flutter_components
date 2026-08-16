# Warcraft Flutter Components

[![pub package](https://img.shields.io/pub/v/warcraft_flutter_components.svg)](https://pub.dev/packages/warcraft_flutter_components)
[![Example](https://img.shields.io/badge/example-live-blue)](https://allingaming.github.io/warcraft_flutter_components/)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-live-blue)](https://allingaming.github.io/warcraft_flutter_components/)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A production-ready fantasy UI kit for Flutter, inspired by the [WarcraftCN](https://www.warcraftcn.com/) React UI. It includes 18 ready-to-use widgets, bundled assets, faction-aware application theming, and a responsive showcase — accessible by default and designed for mobile, desktop, and web.

## Features

- All 18 warcraftcn/ui components, ported to Flutter.
- Faction-themed tabs, checkboxes, avatars, skeletons, toasts, and cursor.
- Custom 9-slice border box rendering for frames and panels, shared across widgets (and exported for your own use).
- Accessible by default: Semantics roles, keyboard activation and tab navigation, minimum tap targets, large-text resilience, and live validation feedback.
- First-class `WarcraftThemeData` extension with classic, Horde, elf, human, and undead palettes.
- Professional hover, focus, pressed, disabled, validation, and supporting-text states.
- Reduced-motion aware transitions, spinners, and shimmer placeholders.
- Controlled and uncontrolled tabs, single/multi-open accordions, and localized pagination navigation.
- Programmatically dismissible toasts, loading buttons, rich menus, and consumer-owned 9-slice frame assets.
- Example app showcasing every component and variant.

## Components

- `WarcraftAccordion`
- `WarcraftAvatar`
- `WarcraftBadge`
- `WarcraftButton`
- `WarcraftCard` (+ `WarcraftCardSection` / `Header` / `Content` / `Footer`)
- `WarcraftCheckbox`
- `WarcraftCursor`
- `WarcraftDropdownMenu`
- `WarcraftInput`
- `WarcraftLabel`
- `WarcraftPagination`
- `WarcraftRadioGroup` / `WarcraftRadio`
- `WarcraftSkeleton`
- `WarcraftSpinner`
- `WarcraftTabs`
- `WarcraftTextarea`
- `WarcraftToast`
- `WarcraftTooltip`

## Install

Requires Flutter 3.35 or newer and Dart 3.9 or newer.

```bash
flutter pub add warcraft_flutter_components
```

Or add to `pubspec.yaml`:

```yaml
dependencies:
  warcraft_flutter_components: ^0.5.0
```

## Usage

```dart
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

MaterialApp(
  theme: WarcraftTheme.themeData(faction: WarcraftFaction.orc),
  home: const MyHomePage(),
);

WarcraftButton(
  variant: WarcraftButtonVariant.frame,
  child: const Text('For the Horde'),
  onPressed: () {},
);
```

### Theme customization

Use a built-in faction palette or provide a customized theme extension. Every
modernized component reads from the nearest `WarcraftThemeData`; existing apps
that do not install one continue to use the classic palette automatically.

```dart
final customTheme = WarcraftThemeData.classic.copyWith(
  primary: const Color(0xFF67E8F9),
  focusRing: const Color(0xFFA5F3FC),
  radius: 12,
);

MaterialApp(
  theme: WarcraftTheme.themeData(data: customTheme),
  home: const MyHomePage(),
);
```

### More examples

```dart
WarcraftInput(
  hintText: 'Enter your name...',
  helperText: 'Shown to your party.',
  prefixIcon: const Icon(Icons.person_outline),
  autofillHints: const [AutofillHints.nickname],
  textCapitalization: TextCapitalization.words,
  maxWidth: 520,
);

WarcraftCard(
  child: const Text('Card content'),
);

WarcraftPagination(
  currentPage: 3,
  pageCount: 10,
  onPageChanged: (page) {},
);

WarcraftLabel(
  text: 'Hero Name',
  isRequired: true,
);

WarcraftToast.show(
  context,
  message: 'Quest complete!',
  type: WarcraftToastType.success,
);

final toast = WarcraftToast.show(
  context,
  message: 'Matchmaking...',
  duration: const Duration(seconds: 30),
);
toast.dismiss();

WarcraftBorderBox(
  asset: 'assets/my-frame.webp',
  package: null,
  sliceInsets: const EdgeInsets.all(24),
  child: const Text('Custom app-owned frame'),
);

WarcraftTabs(
  labels: const ['Overview', 'Stats'],
  contents: const [OverviewPanel(), StatsPanel()],
  selectedIndex: selectedTab,
  onChanged: (index) => setState(() => selectedTab = index),
);

WarcraftTooltip(
  title: 'Frostmourne',
  body: 'Binds when picked up',
  constraints: const BoxConstraints(maxWidth: 280),
  waitDuration: const Duration(milliseconds: 350),
  child: const Icon(Icons.info_outline),
);
```

### Controlled state

Tabs and accordions can be owned by application state. In controlled mode,
interaction calls the change callback and the parent supplies the next value.

```dart
WarcraftAccordion(
  items: questSections,
  expandedIndexes: expandedQuestSections,
  allowMultiple: false,
  onChanged: (index, expanded) {
    setState(() {
      expandedQuestSections = expanded ? {index} : <int>{};
    });
  },
);
```

Omit `expandedIndexes` to use the accordion's internal state. Each
`WarcraftAccordionItem.isExpanded` value is then treated as its initial state.

### Accessibility and localization

Interactive widgets provide semantic roles, state, keyboard focus, and 48dp
minimum targets. Tabs support arrow keys plus Home and End; animations respect
the platform reduced-motion setting. Visible labels are included in checkbox
and radio tap targets.

Pagination's complete accessible vocabulary can be localized independently of
its visible navigation labels:

```dart
WarcraftPagination(
  currentPage: page,
  pageCount: 12,
  previousLabel: 'Nazad',
  nextLabel: 'Napred',
  semanticLabel: 'Stranice zadataka',
  pageSemanticLabelBuilder: (value) => 'Idi na stranu $value',
  currentPageSemanticLabelBuilder: (value) => 'Strana $value, trenutna',
  ellipsisSemanticLabel: 'Još strana',
  onPageChanged: (value) => setState(() => page = value),
);

const WarcraftLabel(
  text: 'Ime heroja',
  isRequired: true,
  requiredSemanticLabel: 'obavezno',
);
```

## Example app

```bash
cd example
flutter run
```

Hosted example (web): https://allingaming.github.io/warcraft_flutter_components/

## Notes

- Asset-heavy widgets rely on the bundled assets under `assets/warcraft/`.
- The package bundles the Cinzel font directly (see `pubspec.yaml`'s `fonts:` section) for the fantasy look — no network fetch, so it works offline and in sandboxed release builds.
- The Flutter 3.35 minimum keeps the package aligned with its accessible validation semantics and the supported `flutter_svg` 2.3 runtime.

## Tests

```bash
flutter test
```

## License

MIT (see `LICENSE`).
