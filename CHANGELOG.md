# Changelog

## 0.2.0

Enterprise-readiness overhaul. Includes breaking API changes (pre-1.0).

- **New components**: `WarcraftToast` (faction/type/position variants, stacking, auto-dismiss) and `WarcraftCursor` (faction hero cursor that follows the pointer on desktop/web) — the package now covers all 18 warcraftcn/ui components.
- **Fixed**: `WarcraftBorderBox` (and by extension every widget built on it) no longer leaks decoded images across rebuilds, now reports asset-resolution errors instead of failing silently, and no longer redundantly re-subscribes its image stream on unrelated dependency changes.
- **Fixed**: `WarcraftInput`/`WarcraftTextarea` no longer duplicate their own buggy copy of the 9-slice image painter — both now delegate to the shared, fixed `WarcraftBorderBox`.
- **Fixed**: `WarcraftDropdownMenu` submenus now open anchored to the tapped item instead of at a fixed, unrelated screen position.
- **Fixed**: `WarcraftAccordion` no longer desyncs its expand/collapse state when a same-length-but-different item list is swapped in, and no longer mutates the item model as a side effect of tapping.
- **Fixed**: `WarcraftSkeleton`'s shimmer sweep now scales with the widget's actual rendered width instead of a hardcoded fallback.
- **Fixed**: `WarcraftCard` no longer forces a 420px minimum height by default — cards size to their content unless `minHeight` is explicitly set.
- **Fixed**: `WarcraftTabs` panel content now scrolls instead of being silently clipped past a fixed height, and tab triggers no longer risk overflow at large text-scale settings.
- **Accessibility**: added `Semantics` for button/checkbox/radio/tooltip/skeleton/spinner, keyboard activation and hover cursor for `WarcraftButton`, and fixed sub-48dp tap targets on `WarcraftRadio`, `WarcraftButton` (`sm`), and pagination's page/nav buttons.
- **API changes**: unified on `enabled: bool` for disabled-state across widgets (dropped a contradictory `required` on nullable `onChanged` callbacks in `WarcraftCheckbox`/`WarcraftRadio`; `WarcraftRadio` gained a real `enabled` field); `WarcraftLabel.required` renamed to `isRequired` to avoid shadowing Dart's `required` keyword.
- **New**: shared `WarcraftTokens` design-token class (spacing, type scale, disabled opacity, minimum tap target) applied consistently across widgets.
- Rebuilt the test suite for full coverage of all 18 widgets, including accessibility guideline tests and regressions for each bug above.
- Rebuilt the example app to demonstrate every widget/variant.
- Packaging cleanup: removed leftover Flutter app scaffolding (`android/ios/linux/macos/windows/web`, a committed `pubspec.lock`) from the package root — not needed for a pure-Dart widget package. `example/` is now excluded from the published pub.dev package via `.pubignore` (it stays in the git repo so the GitHub Pages demo keeps building).

## 0.1.1
- Update dependencies and metadata for pub.dev.

## 0.1.0
- Initial Flutter port of WarcraftCN components.
- Added buttons, badges, cards, inputs, checkboxes, radios, tabs, accordion, pagination, tooltip, spinner, skeleton, avatar, cursor, and dropdown menu.
- Added example app and widget tests.
