# Changelog

## 0.2.0

Enterprise-readiness overhaul. Includes breaking API changes (pre-1.0).

- **New components**: `WarcraftToast` (faction/type/position variants, stacking, auto-dismiss) and `WarcraftCursor` (faction hero cursor that follows the pointer on desktop/web) — the package now covers all 18 warcraftcn/ui components.
- **Fixed**: `WarcraftInput` and `WarcraftTextarea` were slicing their frame artwork incorrectly — `WarcraftInput`'s 9-slice insets didn't account for the source image's real ~72px border thickness (and used no vertical inset at all), so the whole 400px-tall frame, corners included, was uniformly squashed down to the field's actual ~48px height instead of preserving the carved-metal border. Both widgets now expose a `capHeight` alongside `capWidth`, measured directly from their source artwork, and slice symmetrically on both axes.
- **Fixed**: `WarcraftAccordion`'s body panel didn't stretch to match its header's width — the header only happened to fill the available width because of an incidental `Expanded` inside its `Row`, while the body had nothing forcing its width and shrank to fit its content, rendering as a narrow floating box under a full-width header. Both now explicitly stretch via `CrossAxisAlignment.stretch`.
- **Fixed**: `WarcraftTabs`' content panel used an arbitrary `minHeight: 160` that left a large empty gap under short tab content. Replaced with a height derived from the frame artwork's own 48px corner cap, so panels no longer reserve more space than the artwork actually needs.
- **Fixed**: `WarcraftPagination`'s ellipsis indicator used asymmetric padding with no explicit height, so it sat visibly higher than the 48px page/nav buttons beside it in the same row. It now shares the same minimum tap-target height and is vertically centered.
- **Example app**: the showcase page had no maximum content width, so every framed widget (tabs, accordion, cards) stretched to fill the entire window on a wide desktop display. Content is now capped at 960px and centered.
- **Documentation**: added dartdoc comments to every previously-undocumented public class, constructor, field, and enum value across the package (was 31% coverage, now 100%), and enabled the `public_member_api_docs` lint so future additions can't regress this.
- **Tooling**: added a CI workflow (`.github/workflows/ci.yml`) that runs formatting checks, `flutter analyze`, `flutter test`, and a `flutter pub publish --dry-run` on every push and pull request.
- **Fixed**: `WarcraftBorderBox` (and by extension every widget built on it) no longer leaks decoded images across rebuilds, now reports asset-resolution errors instead of failing silently, and no longer redundantly re-subscribes its image stream on unrelated dependency changes.
- **Fixed**: `WarcraftInput`/`WarcraftTextarea` no longer duplicate their own buggy copy of the 9-slice image painter — both now delegate to the shared, fixed `WarcraftBorderBox`.
- **Fixed**: `WarcraftDropdownMenu` submenus now open anchored to the tapped item instead of at a fixed, unrelated screen position; fixed an entry-index desync where a label/separator preceding other entries could route a tap to the wrong item; fixed a runtime `TypeError` when using `WarcraftMenuRadio<T>` with a concrete (non-`dynamic`) `T`.
- **Fixed**: `WarcraftBadge`'s `destructive` variant now gets its own red background wash instead of sharing `defaultVariant`'s exact frame asset and being distinguished only by text color.
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
