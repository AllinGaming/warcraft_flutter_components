import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';

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
  });

  final Widget child;
  final List<WarcraftMenuEntry> items;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: '',
      color: const Color(0xFF1B130B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF6B4A16)),
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
    var index = 0;

    for (final item in source) {
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
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        continue;
      }

      if (item is WarcraftMenuSubmenu) {
        entries.add(
          PopupMenuItem<int>(
            value: index,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: WarcraftTheme.baseTextStyle(context).copyWith(
                      color: WarcraftColors.amber100,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 16, color: Color(0xFFF59E0B)),
              ],
            ),
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
                fontSize: 13,
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
                const SizedBox(width: 8),
                Text(
                  item.label,
                  style: WarcraftTheme.baseTextStyle(context).copyWith(
                    color: WarcraftColors.amber100,
                    fontSize: 13,
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
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 16,
                  color: WarcraftColors.amber400,
                ),
                const SizedBox(width: 8),
                Text(
                  item.label,
                  style: WarcraftTheme.baseTextStyle(context).copyWith(
                    color: WarcraftColors.amber100,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      index += 1;
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
      item.onChanged(item.value);
    } else if (item is WarcraftMenuSubmenu) {
      _showSubmenu(context, item.children);
    }
  }

  void _showSubmenu(BuildContext context, List<WarcraftMenuEntry> submenu) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromLTRB(100, 100, overlay.size.width - 100, 0);

    showMenu<int>(
      context: context,
      position: position,
      color: const Color(0xFF1B130B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF6B4A16)),
      ),
      items: _buildItems(context, submenu),
    ).then((value) {
      if (!context.mounted) return;
      if (value != null) {
        _handleSelected(context, submenu, value);
      }
    });
  }
}
