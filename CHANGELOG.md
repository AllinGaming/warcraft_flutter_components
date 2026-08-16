# Changelog

## 0.5.0

Major design-system and interaction-quality release.

- Raised the supported toolchain floor to Flutter 3.35 and Dart 3.9, and upgraded `flutter_svg` to the 2.3 line so package constraints match the APIs actually used at runtime.
- Added `WarcraftThemeData`, a fully customizable `ThemeExtension` covering surfaces, content, borders, semantic colors, focus rings, elevation shadows, corner radius, disabled opacity, and motion.
- Added `WarcraftTheme.themeData()` with built-in neutral, orc, elf, human, and undead application palettes, plus automatic classic-theme fallback for existing apps.
- Expanded the token system with heading sizes, page-level spacing, corner radii, and motion durations.
- Upgraded buttons with a large size, semantic labels, autofocus, polished hover glow/scale, visible keyboard focus, theme-aware content, and configurable motion.
- Upgraded inputs and textareas with focus/error treatments, helper and validation text, semantic labels, focus control, submission callbacks, read-only/autofocus support, and richer single-line field affordances.
- Expanded input and textarea ergonomics with autofill hints, formatters, capitalization, autocorrect/suggestion control, character limits, text alignment, editing/tap callbacks, and accessible invalid/live-error states.
- Made checkboxes, radios, tabs, and accordion headers keyboard-focusable with Material hover/focus feedback and correct pointer cursors.
- Migrated dropdown menus, tooltips, and toast notifications to theme-driven surfaces, contrast, semantic status colors, radii, and shadows.
- Migrated avatars, badges, cards, labels, radio sockets, loaders, and cursors onto the shared theme, including semantic labels, avatar image fallbacks, and elevated card surfaces.
- Added controlled selection to `WarcraftTabs`, single-open mode and change callbacks to `WarcraftAccordion`, and localized navigation plus strict range validation to `WarcraftPagination`.
- Added conventional arrow-key, Home, and End navigation with focus movement and wraparound to horizontal and vertical tabs; tab labels now tolerate large text more gracefully.
- Made the full radio row—including its visible label—a single tappable and accessible mutually-exclusive control.
- Made checkbox labels and state a single accessible control, and made required labels announce a localizable “required” description instead of their decorative marker.
- Added controlled expansion to `WarcraftAccordion`, including safe transitions back to uncontrolled state, single-open normalization for invalid initial data, merged disclosure semantics, localizable item labels, and const item models.
- Added fully localizable page, current-page, and collapsed-range semantics to `WarcraftPagination`.
- Added package-wide reduced-motion resolution; component transitions collapse to zero duration and continuously animated spinners/shimmers pause when requested by the platform.
- Removed empty editor metadata from bundled SVG icons so `flutter_svg` renders them without unsupported-element diagnostics.
- Fixed toast overlay and registry retention after the final notification exits; `WarcraftToast.show` now returns an idempotent controller for early dismissal and toast cards expose an accessible dismiss action.
- Added loading/progress state support to `WarcraftButton`, including blocked activation, animated content replacement, and appropriate progress semantics.
- Expanded dropdown menus with leading/trailing content, disabled checkbox/radio/submenu states, selection semantics, localized trigger tooltips, popup offsets, and custom constraints.
- Upgraded `WarcraftBorderBox` to support consumer-app assets via `package: null`, configurable sampling, handled asset errors, loading/error fallback decoration, and correctly unclipped elevation shadows.
- Expanded tooltip timing, placement, padding, sizing, and tap-dismiss configuration for responsive application layouts.
- Rebuilt the example as a responsive professional component showroom with live faction-palette switching, clearer hierarchy, contextual descriptions, and polished surfaces.
- Preserved the existing component API defaults while establishing a cohesive pre-stable theming foundation.

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
