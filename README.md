# warcraft_flutter_components

Warcraft-themed Flutter UI components inspired by the WarcraftCN React UI. Includes ready-to-use widgets, themed assets, and an example app.

**Components**
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

**Install**
```yaml
dependencies:
  warcraft_flutter_components: ^0.1.0
```

**Usage**
```dart
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

WarcraftButton(
  variant: WarcraftButtonVariant.frame,
  child: const Text('For the Horde'),
  onPressed: () {},
);
```

**Examples**
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

**Example app**
```bash
cd example
flutter run
```

**Notes**
- Asset-heavy widgets (tabs, accordion, buttons) rely on the bundled assets under `assets/warcraft/`.
- The package uses the Cinzel font via `google_fonts` for the fantasy look.
