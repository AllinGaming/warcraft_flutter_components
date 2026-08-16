import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Base class for Warcraft dropdown menu entries.
abstract class WarcraftMenuEntry {
  /// Const constructor for subclasses.
  const WarcraftMenuEntry();
}

/// Clickable menu action item.
class WarcraftMenuAction extends WarcraftMenuEntry {
  /// Creates a [WarcraftMenuAction] with the given [label] and [onSelected]
  /// callback.
  const WarcraftMenuAction({
    required this.label,
    this.onSelected,
    this.enabled = true,
    this.leading,
    this.trailing,
  });

  /// The text shown for this action.
  final String label;

  /// Called when the user selects this action.
  final VoidCallback? onSelected;

  /// Whether this action can be selected. Defaults to `true`; disabled
  /// actions are shown but not tappable.
  final bool enabled;

  /// Optional widget displayed before [label].
  final Widget? leading;

  /// Optional widget displayed after [label], such as a shortcut hint.
  final Widget? trailing;
}

/// Checkbox item for menus.
class WarcraftMenuCheckbox extends WarcraftMenuEntry {
  /// Creates a [WarcraftMenuCheckbox] with the given [label], current
  /// [value], and [onChanged] callback.
  const WarcraftMenuCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  /// The text shown next to the checkbox.
  final String label;

  /// Whether the checkbox is currently checked.
  final bool value;

  /// Called with the new checked state when the item is selected.
  final ValueChanged<bool> onChanged;

  /// Whether this checkbox entry can be selected.
  final bool enabled;
}

/// Radio item for menus.
class WarcraftMenuRadio<T> extends WarcraftMenuEntry {
  /// Creates a [WarcraftMenuRadio] with the given [label], [value],
  /// [groupValue], and [onChanged] callback.
  const WarcraftMenuRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.enabled = true,
  });

  /// The text shown next to the radio button.
  final String label;

  /// The value represented by this radio item.
  final T value;

  /// The currently selected value for the radio group; this item renders as
  /// selected when it equals [value].
  final T groupValue;

  /// Called with [value] when this item is selected.
  final ValueChanged<T> onChanged;

  /// Whether this radio entry can be selected.
  final bool enabled;

  /// Invokes [onChanged] with [value].
  ///
  /// Called through the object's own (dynamically dispatched) method rather
  /// than externally as `item.onChanged(item.value)` after an `is
  /// WarcraftMenuRadio` check — that pattern reads both members through the
  /// *unparameterized* promoted type `WarcraftMenuRadio<dynamic>`, which
  /// throws a runtime `TypeError` for any concrete, non-`dynamic` `T` (e.g.
  /// `WarcraftMenuRadio<String>`) since `void Function(String)` is not a
  /// subtype of `void Function(dynamic)`. Calling it as an instance method
  /// keeps `T` consistent on both sides.
  void select() => onChanged(value);
}

/// Section label for menus.
class WarcraftMenuLabel extends WarcraftMenuEntry {
  /// Creates a [WarcraftMenuLabel] displaying [label].
  const WarcraftMenuLabel(this.label);

  /// The section label text, rendered upper-cased.
  final String label;
}

/// Divider item for menus.
class WarcraftMenuSeparator extends WarcraftMenuEntry {
  /// Creates a [WarcraftMenuSeparator].
  const WarcraftMenuSeparator();
}

/// Submenu item containing nested entries.
class WarcraftMenuSubmenu extends WarcraftMenuEntry {
  /// Creates a [WarcraftMenuSubmenu] with the given [label] and nested
  /// [children].
  const WarcraftMenuSubmenu({
    required this.label,
    required this.children,
    this.enabled = true,
    this.leading,
  });

  /// The text shown for this submenu entry.
  final String label;

  /// The nested entries shown when this submenu is opened.
  final List<WarcraftMenuEntry> children;

  /// Whether the nested menu can be opened.
  final bool enabled;

  /// Optional widget displayed before [label].
  final Widget? leading;
}

/// Warcraft-themed dropdown menu wrapper.
class WarcraftDropdownMenu extends StatelessWidget {
  /// Creates a [WarcraftDropdownMenu] wrapping [child], showing [items] when
  /// opened.
  const WarcraftDropdownMenu({
    super.key,
    required this.child,
    required this.items,
    this.enabled = true,
    this.tooltip = 'Open menu',
    this.offset = Offset.zero,
    this.constraints = const BoxConstraints(minWidth: 220, maxWidth: 320),
  });

  /// The widget that triggers the menu when tapped.
  final Widget child;

  /// The entries shown in the dropdown menu.
  final List<WarcraftMenuEntry> items;

  /// Whether the menu can be opened. Defaults to `true`.
  final bool enabled;

  /// Accessible tooltip for the menu trigger.
  final String tooltip;

  /// Offset applied to the popup relative to its trigger.
  final Offset offset;

  /// Width constraints applied to the popup menu.
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    return PopupMenuButton<int>(
      tooltip: tooltip,
      enabled: enabled,
      offset: offset,
      color: theme.surfaceElevated,
      elevation: 12,
      constraints: constraints,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius),
        side: BorderSide(color: theme.border),
      ),
      itemBuilder: (context) => _buildItems(context, items),
      onSelected: (index) => _handleSelected(context, items, index),
      child: child,
    );
  }

  List<PopupMenuEntry<int>> _buildItems(
    BuildContext context,
    List<WarcraftMenuEntry> source,
  ) {
    final entries = <PopupMenuEntry<int>>[];
    final theme = WarcraftTheme.of(context);

    // A plain indexed loop (rather than a running counter incremented via
    // `continue`) keeps each entry's `value: index` trivially in sync with
    // its real position in `source` — `_handleSelected` indexes back into
    // `source` by that same value, so any divergence (e.g. a separator or
    // label skipping the increment) would route a tap to the wrong entry.
    for (var index = 0; index < source.length; index++) {
      final item = source[index];

      if (item is WarcraftMenuSeparator) {
        entries.add(const PopupMenuDivider(height: 8));
        continue;
      }

      if (item is WarcraftMenuLabel) {
        entries.add(
          PopupMenuItem<int>(
            enabled: false,
            child: Text(
              item.label.toUpperCase(),
              style: WarcraftTheme.baseTextStyle(context).copyWith(
                color: theme.primary.withAlpha(190),
                fontSize: WarcraftTokens.typeSm,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        continue;
      }

      if (item is WarcraftMenuSubmenu) {
        late BuildContext itemContext;
        entries.add(
          PopupMenuItem<int>(
            enabled: item.enabled,
            onTap: item.enabled
                ? () => _openSubmenu(context, itemContext, item)
                : null,
            child: Builder(
              builder: (ctx) {
                itemContext = ctx;
                return Row(
                  children: [
                    if (item.leading != null) ...[
                      IconTheme.merge(
                        data: IconThemeData(
                          color: item.enabled
                              ? theme.primary
                              : theme.mutedForeground,
                          size: 18,
                        ),
                        child: item.leading!,
                      ),
                      const SizedBox(width: WarcraftTokens.spacingSm),
                    ],
                    Expanded(
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: WarcraftTheme.baseTextStyle(context).copyWith(
                          color: item.enabled
                              ? theme.foreground
                              : theme.mutedForeground,
                          fontSize: WarcraftTokens.typeBase,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: item.enabled
                          ? theme.primary
                          : theme.mutedForeground,
                    ),
                  ],
                );
              },
            ),
          ),
        );
      } else if (item is WarcraftMenuAction) {
        entries.add(
          PopupMenuItem<int>(
            value: index,
            enabled: item.enabled,
            child: Row(
              children: [
                if (item.leading != null) ...[
                  IconTheme.merge(
                    data: IconThemeData(
                      color: item.enabled
                          ? theme.primary
                          : theme.mutedForeground,
                      size: 18,
                    ),
                    child: item.leading!,
                  ),
                  const SizedBox(width: WarcraftTokens.spacingSm),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: WarcraftTheme.baseTextStyle(context).copyWith(
                      color: item.enabled
                          ? theme.foreground
                          : theme.mutedForeground,
                      fontSize: WarcraftTokens.typeBase,
                    ),
                  ),
                ),
                if (item.trailing != null) ...[
                  const SizedBox(width: WarcraftTokens.spacingMd),
                  DefaultTextStyle.merge(
                    style: WarcraftTheme.baseTextStyle(context).copyWith(
                      color: theme.mutedForeground,
                      fontSize: WarcraftTokens.typeSm,
                    ),
                    child: item.trailing!,
                  ),
                ],
              ],
            ),
          ),
        );
      } else if (item is WarcraftMenuCheckbox) {
        entries.add(
          PopupMenuItem<int>(
            value: index,
            enabled: item.enabled,
            child: Semantics(
              checked: item.value,
              enabled: item.enabled,
              label: item.label,
              excludeSemantics: true,
              child: Row(
                children: [
                  Icon(
                    item.value ? Icons.check : Icons.check_box_outline_blank,
                    size: 16,
                    color: item.enabled ? theme.primary : theme.mutedForeground,
                  ),
                  const SizedBox(width: WarcraftTokens.spacingSm),
                  Text(
                    item.label,
                    style: WarcraftTheme.baseTextStyle(context).copyWith(
                      color: item.enabled
                          ? theme.foreground
                          : theme.mutedForeground,
                      fontSize: WarcraftTokens.typeBase,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (item is WarcraftMenuRadio) {
        final selected = item.value == item.groupValue;
        entries.add(
          PopupMenuItem<int>(
            value: index,
            enabled: item.enabled,
            child: Semantics(
              checked: selected,
              enabled: item.enabled,
              inMutuallyExclusiveGroup: true,
              label: item.label,
              excludeSemantics: true,
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 16,
                    color: item.enabled ? theme.primary : theme.mutedForeground,
                  ),
                  const SizedBox(width: WarcraftTokens.spacingSm),
                  Text(
                    item.label,
                    style: WarcraftTheme.baseTextStyle(context).copyWith(
                      color: item.enabled
                          ? theme.foreground
                          : theme.mutedForeground,
                      fontSize: WarcraftTokens.typeBase,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return entries;
  }

  void _handleSelected(
    BuildContext context,
    List<WarcraftMenuEntry> source,
    int index,
  ) {
    final item = source[index];
    if (item is WarcraftMenuAction) {
      item.onSelected?.call();
    } else if (item is WarcraftMenuCheckbox && item.enabled) {
      item.onChanged(!item.value);
    } else if (item is WarcraftMenuRadio && item.enabled) {
      item.select();
    }
  }

  /// Computes the submenu's anchor position from the tapped item's own
  /// [itemContext] *before* the current menu route finishes closing (its
  /// [RenderBox] would otherwise be detached), then opens the submenu on the
  /// next frame using the stable, still-mounted outer [context].
  void _openSubmenu(
    BuildContext context,
    BuildContext itemContext,
    WarcraftMenuSubmenu item,
  ) {
    final overlayBox =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final itemBox = itemContext.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        itemBox.localToGlobal(Offset.zero, ancestor: overlayBox),
        itemBox.localToGlobal(
          itemBox.size.bottomRight(Offset.zero),
          ancestor: overlayBox,
        ),
      ),
      Offset.zero & overlayBox.size,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        _showSubmenu(context, item.children, position);
      }
    });
  }

  void _showSubmenu(
    BuildContext context,
    List<WarcraftMenuEntry> submenu,
    RelativeRect position,
  ) {
    final theme = WarcraftTheme.of(context);
    showMenu<int>(
      context: context,
      position: position,
      color: theme.surfaceElevated,
      elevation: 12,
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius),
        side: BorderSide(color: theme.border),
      ),
      items: _buildItems(context, submenu),
    ).then((value) {
      if (!context.mounted || value == null) return;
      _handleSelected(context, submenu, value);
    });
  }
}
