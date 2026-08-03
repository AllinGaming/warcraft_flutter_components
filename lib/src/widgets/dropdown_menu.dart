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
  });

  /// The text shown for this action.
  final String label;

  /// Called when the user selects this action.
  final VoidCallback? onSelected;

  /// Whether this action can be selected. Defaults to `true`; disabled
  /// actions are shown but not tappable.
  final bool enabled;
}

/// Checkbox item for menus.
class WarcraftMenuCheckbox extends WarcraftMenuEntry {
  /// Creates a [WarcraftMenuCheckbox] with the given [label], current
  /// [value], and [onChanged] callback.
  const WarcraftMenuCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  /// The text shown next to the checkbox.
  final String label;

  /// Whether the checkbox is currently checked.
  final bool value;

  /// Called with the new checked state when the item is selected.
  final ValueChanged<bool> onChanged;
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
  });

  /// The text shown for this submenu entry.
  final String label;

  /// The nested entries shown when this submenu is opened.
  final List<WarcraftMenuEntry> children;
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
  });

  /// The widget that triggers the menu when tapped.
  final Widget child;

  /// The entries shown in the dropdown menu.
  final List<WarcraftMenuEntry> items;

  /// Whether the menu can be opened. Defaults to `true`.
  final bool enabled;

  static const _menuColor = Color(0xFF1B130B);
  static const _menuBorderColor = Color(0xFF6B4A16);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: '',
      enabled: enabled,
      color: _menuColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: _menuBorderColor),
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
                color: WarcraftColors.amber400.withAlpha(178),
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
            child: Builder(
              builder: (ctx) {
                itemContext = ctx;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: WarcraftTheme.baseTextStyle(context).copyWith(
                          color: WarcraftColors.amber100,
                          fontSize: WarcraftTokens.typeBase,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        size: 16, color: Color(0xFFF59E0B)),
                  ],
                );
              },
            ),
            onTap: () => _openSubmenu(context, itemContext, item),
          ),
        );
      } else if (item is WarcraftMenuAction) {
        entries.add(
          PopupMenuItem<int>(
            value: index,
            enabled: item.enabled,
            child: Text(
              item.label,
              style: WarcraftTheme.baseTextStyle(context).copyWith(
                color: WarcraftColors.amber100,
                fontSize: WarcraftTokens.typeBase,
              ),
            ),
          ),
        );
      } else if (item is WarcraftMenuCheckbox) {
        entries.add(
          PopupMenuItem<int>(
            value: index,
            child: Row(
              children: [
                Icon(
                  item.value ? Icons.check : Icons.check_box_outline_blank,
                  size: 16,
                  color: WarcraftColors.amber400,
                ),
                const SizedBox(width: WarcraftTokens.spacingSm),
                Text(
                  item.label,
                  style: WarcraftTheme.baseTextStyle(context).copyWith(
                    color: WarcraftColors.amber100,
                    fontSize: WarcraftTokens.typeBase,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (item is WarcraftMenuRadio) {
        final selected = item.value == item.groupValue;
        entries.add(
          PopupMenuItem<int>(
            value: index,
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 16,
                  color: WarcraftColors.amber400,
                ),
                const SizedBox(width: WarcraftTokens.spacingSm),
                Text(
                  item.label,
                  style: WarcraftTheme.baseTextStyle(context).copyWith(
                    color: WarcraftColors.amber100,
                    fontSize: WarcraftTokens.typeBase,
                  ),
                ),
              ],
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
    } else if (item is WarcraftMenuCheckbox) {
      item.onChanged(!item.value);
    } else if (item is WarcraftMenuRadio) {
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
        itemBox.localToGlobal(itemBox.size.bottomRight(Offset.zero),
            ancestor: overlayBox),
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
    showMenu<int>(
      context: context,
      position: position,
      color: _menuColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: _menuBorderColor),
      ),
      items: _buildItems(context, submenu),
    ).then((value) {
      if (!context.mounted || value == null) return;
      _handleSelected(context, submenu, value);
    });
  }
}
