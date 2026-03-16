# Warcraft Flutter Components

[![pub package](https://img.shields.io/pub/v/warcraft_flutter_components.svg)](https://pub.dev/packages/warcraft_flutter_components)
[![Example](https://img.shields.io/badge/example-live-blue)](https://allingaming.github.io/warcraft_flutter_components/)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-live-blue)](https://allingaming.github.io/warcraft_flutter_components/)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Warcraft-themed Flutter UI components inspired by the WarcraftCN React UI. Includes ready-to-use widgets, themed assets, and a full example app.

## Features

- Ready-made Warcraft UI widgets (buttons, cards, tabs, inputs, etc).
- Faction-themed tabs and visual variants.
- Custom 9-slice border box rendering for frames and panels.
- Example app showcasing all components.

## Components

- `WarcraftAccordion`
- `WarcraftAvatar`
- `WarcraftBadge`
- `WarcraftButton`
- `WarcraftCard`
- `WarcraftCheckbox`
- `WarcraftDropdownMenu`
- `WarcraftInput`
- `WarcraftLabel`
- `WarcraftPagination`
- `WarcraftRadioGroup` / `WarcraftRadio`
- `WarcraftSkeleton`
- `WarcraftSpinner`
- `WarcraftTabs`
- `WarcraftTextarea`
- `WarcraftTooltip`

## Install

```bash
flutter pub add warcraft_flutter_components
```

Or add to `pubspec.yaml`:

```yaml
dependencies:
  warcraft_flutter_components: ^0.1.0
```

## Usage

```dart
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

WarcraftButton(
  variant: WarcraftButtonVariant.frame,
  child: const Text('For the Horde'),
  onPressed: () {},
);
```

### More examples

```dart
WarcraftInput(
  hintText: 'Enter your name...',
  capWidth: 28,
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
```

## Example app

```bash
cd example
flutter run
```

Hosted example (web): https://allingaming.github.io/warcraft_flutter_components/

## Notes

- Asset-heavy widgets rely on the bundled assets under `assets/warcraft/`.
- The package uses the Cinzel font via `google_fonts` for the fantasy look.

## Tests

```bash
flutter test
```

## License

MIT (see `LICENSE`).
