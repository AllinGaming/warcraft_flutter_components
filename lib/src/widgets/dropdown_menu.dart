import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Base class for Warcraft dropdown menu entries.
abstract class WarcraftMenuEntry {
  const WarcraftMenuEntry();
}

/// Clickable menu action item.
class WarcraftMenuAction extends WarcraftMenuEntry {
  const WarcraftMenuAction({
    required this.label,
    this.onSelected,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onSelected;
  final bool enabled;
}

/// Checkbox item for menus.
class WarcraftMenuCheckbox extends WarcraftMenuEntry {
  const WarcraftMenuCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
}

/// Radio item for menus.
class WarcraftMenuRadio<T> extends WarcraftMenuEntry {
  const WarcraftMenuRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final T value;
  final T groupValue;
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
  const WarcraftMenuLabel(this.label);
  final String label;
}

/// Divider item for menus.
class WarcraftMenuSeparator extends WarcraftMenuEntry {
  const WarcraftMenuSeparator();
}

/// Submenu item containing nested entries.
class WarcraftMenuSubmenu extends WarcraftMenuEntry {
  const WarcraftMenuSubmenu({
    required this.label,
    required this.children,
  });

  final String label;
  final List<WarcraftMenuEntry> children;
}

/// Warcraft-themed dropdown menu wrapper.
class WarcraftDropdownMenu extends StatelessWidget {
  const WarcraftDropdownMenu({
    super.key,
    required this.child,
    required this.items,
    this.enabled = true,
  });

  final Widget child;
  final List<WarcraftMenuEntry> items;
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
